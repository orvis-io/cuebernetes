// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

package v1beta1

import "strings"

// Receiver is the Schema for the receivers API
#Receiver: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "notification.toolkit.fluxcd.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Receiver"
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

	// ReceiverSpec defines the desired state of Receiver
	spec!: #ReceiverSpec
}

// ReceiverSpec defines the desired state of Receiver
#ReceiverSpec: {
	// A list of events to handle,
	// e.g. 'push' for GitHub or 'Push Hook' for GitLab.
	events?: [...string]

	// A list of resources to be notified about changes.
	resources: [...{
		// API version of the referent
		apiVersion?: string

		// Kind of the referent
		kind?: "Bucket" | "GitRepository" | "Kustomization" | "HelmRelease" | "HelmChart" | "HelmRepository" | "ImageRepository" | "ImagePolicy" | "ImageUpdateAutomation" | "OCIRepository"

		// MatchLabels is a map of {key,value} pairs. A single {key,value}
		// in the matchLabels
		// map is equivalent to an element of matchExpressions, whose key
		// field is "key", the
		// operator is "In", and the values array contains only "value".
		// The requirements are ANDed.
		matchLabels?: {
			[string]: string
		}

		// Name of the referent
		name: strings.MaxRunes(53) & strings.MinRunes(1)

		// Namespace of the referent
		namespace?: strings.MaxRunes(53) & strings.MinRunes(1)
	}]
	secretRef?: {
		// Name of the referent.
		name: string
	}

	// This flag tells the controller to suspend subsequent events
	// handling.
	// Defaults to false.
	suspend?: bool

	// Type of webhook sender, used to determine
	// the validation procedure and payload deserialization.
	type: "generic" | "generic-hmac" | "github" | "gitlab" | "bitbucket" | "harbor" | "dockerhub" | "quay" | "gcr" | "nexus" | "acr"
}
