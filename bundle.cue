#Config: {
  distro: "talos"
  kubeProxyReplacement: true
  k8sServiceHost: "localhost"
  k8sServicePort: 7445
  ...
}

bundle: {
  apiVersion: "v1alpha1"
  name:       "flux-aio"
  instances: {
    "flux": {
      module: url: "oci://ghcr.io/stefanprodan/modules/flux-aio"
      namespace: "flux-system"
      values: {
        hostNetwork:     true
        securityProfile: "privileged"
        env: {
          "KUBERNETES_SERVICE_HOST": #Config.k8sServiceHost
          "KUBERNETES_SERVICE_PORT": "\(#Config.k8sServicePort)"
        }
      }
    }
    "cilium": {
      module: url: "file://./modules/cilium"
      namespace: "cuebernetes"
      values: #Config & {
        chart: version: "1.16.1"
      }
    }
    "metallb": {
      module: url: "file://./modules/metallb"
      namespace: "cuebernetes"
      values: #Config & {
        chart: version: "0.14.8"
      }
    }
    "envoy-gateway": {
      module: url: "file://./modules/envoygateway"
      namespace: "cuebernetes"
      values: #Config & {
        chart: version: "1.1.0"
      }
    }
    "kubevirt": {
      module: url: "file://./modules/kubevirt"
      namespace: "cuebernetes"
      values: #Config & {
        targetNamespace: "kubevirt-system"
      }
    }
  }
}