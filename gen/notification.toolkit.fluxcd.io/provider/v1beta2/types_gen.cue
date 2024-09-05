// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

package v1beta2

import "strings"

// Provider is the Schema for the providers API.
#Provider: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "notification.toolkit.fluxcd.io/v1beta2"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Provider"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// ProviderSpec defines the desired state of the Provider.
	spec!: #ProviderSpec
}

// ProviderSpec defines the desired state of the Provider.
#ProviderSpec: {
	// Address specifies the endpoint, in a generic sense, to where
	// alerts are sent.
	// What kind of endpoint depends on the specific Provider type
	// being used.
	// For the generic Provider, for example, this is an HTTP/S
	// address.
	// For other Provider types this could be a project ID or a
	// namespace.
	address?: strings.MaxRunes(2048)
	certSecretRef?: {
		// Name of the referent.
		name: string
	}

	// Channel specifies the destination channel where events should
	// be posted.
	channel?: strings.MaxRunes(2048)

	// Interval at which to reconcile the Provider with its Secret
	// references.
	interval?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"

	// Proxy the HTTP/S address of the proxy server.
	proxy?: strings.MaxRunes(2048) & {
		=~"^(http|https)://.*$"
	}
	secretRef?: {
		// Name of the referent.
		name: string
	}

	// Suspend tells the controller to suspend subsequent
	// events handling for this Provider.
	suspend?: bool

	// Timeout for sending alerts to the Provider.
	timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m))+$"

	// Type specifies which Provider implementation to use.
	type: "slack" | "discord" | "msteams" | "rocket" | "generic" | "generic-hmac" | "github" | "gitlab" | "gitea" | "bitbucketserver" | "bitbucket" | "azuredevops" | "googlechat" | "googlepubsub" | "webex" | "sentry" | "azureeventhub" | "telegram" | "lark" | "matrix" | "opsgenie" | "alertmanager" | "grafana" | "githubdispatch" | "pagerduty" | "datadog"

	// Username specifies the name under which events are posted.
	username?: strings.MaxRunes(2048)
}
