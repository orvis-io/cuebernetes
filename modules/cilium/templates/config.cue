package templates

import (
	timoniv1 "cuebernetes.orvis.io/timoni/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: timoniv1.#Module & timoniv1.#HelmReleaseConfig & {
	kubeProxyReplacement: bool | *false
	if kubeProxyReplacement {
	  k8sServiceHost: string
	  k8sServicePort: int
	}
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config & {
		helmValues: {
			kubeProxyReplacement: config.kubeProxyReplacement
			k8sServiceHost?: config.k8sServiceHost
			k8sServicePort?: config.k8sServicePort
    	if config.distro == "talos" {
        securityContext: capabilities: {
          ciliumAgent: ["CHOWN", "KILL", "NET_ADMIN", "NET_RAW", "IPC_LOCK", "SYS_ADMIN", "SYS_RESOURCE", "DAC_OVERRIDE", "FOWNER", "SETGID", "SETUID"]
          cleanCiliumState: ["NET_ADMIN", "SYS_ADMIN", "SYS_RESOURCE"]
        }
        cgroup: {
          autoMount: enabled: true
          hostRoot: "/sys/fs/cgroup"
        }
	    }
		}
	}

	_release: timoniv1.#HelmRelease & {#config: config}
	objects: _release.objects
}