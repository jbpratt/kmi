FROM ghcr.io/bkahlert/libguestfs:latest as sysprep

ARG TARGETARCH
ARG FLAVOR=${FLAVOR}
ARG VERSION=${VERSION}
ARG PKG_LIST=${PKG_LIST}

WORKDIR /disk

COPY index.json   index.json
COPY virt.sysprep virt.sysprep

USER root

RUN apt install -y jq

# Download Image
# TODO: need to convert ${VERSION} from integer to string 
RUN set -ex \
    && echo ${DOWNLOAD_URL} \
    && curl --output source.${FLAVOR}.qcow2 -L $(jq .distributions.${FLAVOR}.v${VERSION}.${TARGETARCH}.url index.json) \
    && echo;

RUN set -ex \
    && qemu-img resize source.${FLAVOR}.qcow2 +20G                                \
    && virt-sparsify -v --compress source.${FLAVOR}.qcow2 ${FLAVOR}.qcow2         \
    && rm source.${FLAVOR}.qcow2                                                  \
    && echo;

# Sysprep Image
RUN set -ex \
    && virt-sysprep -va ${FLAVOR}.qcow2                                           \
         --network                                                                \
         --install ${PKG_LIST}                                                                \
         --commands-from-file virt.sysprep                                        \
         --enable user-account,logfiles,customize,bash-history,net-hostname,net-hwaddr,machine-id,dhcp-server-state,dhcp-client-state,yum-uuid,udev-persistent-net,tmp-files,smolt-uuid,rpm-db,package-manager-cache \
    && virt-sparsify --compress ${FLAVOR}.qcow2 ${FLAVOR}.sparse.qcow2            \
    && rm ${FLAVOR}.qcow2                                                         \
    && qemu-img info ${FLAVOR}.sparse.qcow2                                       \
    && echo;

# Copy disk image into cradle
FROM scratch
ARG FLAVOR=${FLAVOR}
COPY --from=sysprep /disk/${FLAVOR}.sparse.qcow2 /disk/${FLAVOR}.qcow2
