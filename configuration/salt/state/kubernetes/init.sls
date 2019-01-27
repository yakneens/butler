kube_repo:
  pkgrepo.managed:
    - humanname: Kubernetes YUM Repo
    - baseurl: https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    - gpgkey: https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg


kube_svcs:
  pkg.latest:
    - pkgs:
      - kubelet
      - kubeadm
      - kubectl

enable_on_boot_kubelet:
  service.enabled:
    - name: kubelet
