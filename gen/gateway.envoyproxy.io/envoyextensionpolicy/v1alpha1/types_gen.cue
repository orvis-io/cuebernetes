// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f crds.yaml

package v1alpha1

import (
	"strings"
	"list"
)

// EnvoyExtensionPolicy allows the user to configure various envoy
// extensibility options for the Gateway.
#EnvoyExtensionPolicy: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "gateway.envoyproxy.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "EnvoyExtensionPolicy"
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

	// Spec defines the desired state of EnvoyExtensionPolicy.
	spec!: #EnvoyExtensionPolicySpec
}

// Spec defines the desired state of EnvoyExtensionPolicy.
#EnvoyExtensionPolicySpec: {
	// ExtProc is an ordered list of external processing filters
	// that should added to the envoy filter chain
	extProc?: list.MaxItems(16) & [...{
		// BackendRefs defines the configuration of the external
		// processing service
		backendRefs: list.MaxItems(1) & [...{
			// Group is the group of the referent. For example,
			// "gateway.networking.k8s.io".
			// When unspecified or empty string, core API group is inferred.
			group?: strings.MaxRunes(253) & =~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" | *""

			// Kind is the Kubernetes resource kind of the referent. For
			// example
			// "Service".
			//
			//
			// Defaults to "Service" when not specified.
			//
			//
			// ExternalName services can refer to CNAME DNS records that may
			// live
			// outside of the cluster and as such are difficult to reason
			// about in
			// terms of conformance. They also may not be safe to forward to
			// (see
			// CVE-2021-25740 for more information). Implementations SHOULD
			// NOT
			// support ExternalName Services.
			//
			//
			// Support: Core (Services with a type other than ExternalName)
			//
			//
			// Support: Implementation-specific (Services with type
			// ExternalName)
			kind?: strings.MaxRunes(63) & strings.MinRunes(1) & =~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$" | *"Service"

			// Name is the name of the referent.
			name: strings.MaxRunes(253) & strings.MinRunes(1)

			// Namespace is the namespace of the backend. When unspecified,
			// the local
			// namespace is inferred.
			//
			//
			// Note that when a namespace different than the local namespace
			// is specified,
			// a ReferenceGrant object is required in the referent namespace
			// to allow that
			// namespace's owner to accept the reference. See the
			// ReferenceGrant
			// documentation for details.
			//
			//
			// Support: Core
			namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
				=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"
			}

			// Port specifies the destination port number to use for this
			// resource.
			// Port is required when the referent is a Kubernetes Service. In
			// this
			// case, the port number is the service port number, not the
			// target port.
			// For other resources, destination port might be derived from the
			// referent
			// resource or this field.
			port?: uint16 & >=1
		}] & [_, ...]

		// FailOpen defines if requests or responses that cannot be
		// processed due to connectivity to the
		// external processor are terminated or passed-through.
		// Default: false
		failOpen?: bool

		// MessageTimeout is the timeout for a response to be returned
		// from the external processor
		// Default: 200ms
		messageTimeout?: =~"^([0-9]{1,5}(h|m|s|ms)){1,4}$"

		// ProcessingMode defines how request and response body is
		// processed
		// Default: header and body are not sent to the external processor
		processingMode?: {
			request?: {
				// Defines body processing mode
				body?: "Streamed" | "Buffered" | "BufferedPartial"
			}
			response?: {
				// Defines body processing mode
				body?: "Streamed" | "Buffered" | "BufferedPartial"
			}
		}
	}]

	// TargetRef is the name of the resource this policy is being
	// attached to.
	// This policy and the TargetRef MUST be in the same namespace for
	// this
	// Policy to have effect
	//
	//
	// Deprecated: use targetRefs/targetSelectors instead
	targetRef?: {
		// Group is the group of the target resource.
		group: strings.MaxRunes(253) & {
			=~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$"
		}

		// Kind is kind of the target resource.
		kind: strings.MaxRunes(63) & strings.MinRunes(1) & {
			=~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$"
		}

		// Name is the name of the target resource.
		name: strings.MaxRunes(253) & strings.MinRunes(1)

		// SectionName is the name of a section within the target
		// resource. When
		// unspecified, this targetRef targets the entire resource. In the
		// following
		// resources, SectionName is interpreted as the following:
		//
		//
		// * Gateway: Listener name
		// * HTTPRoute: HTTPRouteRule name
		// * Service: Port name
		//
		//
		// If a SectionName is specified, but does not exist on the
		// targeted object,
		// the Policy must fail to attach, and the policy implementation
		// should record
		// a `ResolvedRefs` or similar Condition in the Policy's status.
		sectionName?: strings.MaxRunes(253) & strings.MinRunes(1) & {
			=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$"
		}
	}

	// TargetRefs are the names of the Gateway resources this policy
	// is being attached to.
	targetRefs?: [...{
		// Group is the group of the target resource.
		group: strings.MaxRunes(253) & {
			=~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$"
		}

		// Kind is kind of the target resource.
		kind: strings.MaxRunes(63) & strings.MinRunes(1) & {
			=~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$"
		}

		// Name is the name of the target resource.
		name: strings.MaxRunes(253) & strings.MinRunes(1)

		// SectionName is the name of a section within the target
		// resource. When
		// unspecified, this targetRef targets the entire resource. In the
		// following
		// resources, SectionName is interpreted as the following:
		//
		//
		// * Gateway: Listener name
		// * HTTPRoute: HTTPRouteRule name
		// * Service: Port name
		//
		//
		// If a SectionName is specified, but does not exist on the
		// targeted object,
		// the Policy must fail to attach, and the policy implementation
		// should record
		// a `ResolvedRefs` or similar Condition in the Policy's status.
		sectionName?: strings.MaxRunes(253) & strings.MinRunes(1) & {
			=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$"
		}
	}]

	// TargetSelectors allow targeting resources for this policy based
	// on labels
	targetSelectors?: [...{
		// Group is the group that this selector targets. Defaults to
		// gateway.networking.k8s.io
		group?: strings.MaxRunes(253) & =~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" | *"gateway.networking.k8s.io"

		// Kind is the resource kind that this selector targets.
		kind: strings.MaxRunes(63) & strings.MinRunes(1) & {
			=~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$"
		}

		// MatchLabels are the set of label selectors for identifying the
		// targeted resource
		matchLabels: {
			[string]: string
		}
	}]

	// Wasm is a list of Wasm extensions to be loaded by the Gateway.
	// Order matters, as the extensions will be loaded in the order
	// they are
	// defined in this list.
	wasm?: list.MaxItems(16) & [...{
		// Code is the Wasm code for the extension.
		code: {
			// HTTP is the HTTP URL containing the Wasm code.
			//
			//
			// Note that the HTTP server must be accessible from the Envoy
			// proxy.
			http?: {
				// SHA256 checksum that will be used to verify the Wasm code.
				//
				//
				// If not specified, Envoy Gateway will not verify the downloaded
				// Wasm code.
				// kubebuilder:validation:Pattern=`^[a-f0-9]{64}$`
				sha256?: string

				// URL is the URL containing the Wasm code.
				url: =~"^((https?:)(\\/\\/\\/?)([\\w]*(?::[\\w]*)?@)?([\\d\\w\\.-]+)(?::(\\d+))?)?([\\/\\\\\\w\\.()-]*)?(?:([?][^#]*)?(#.*)?)*"
			}

			// Image is the OCI image containing the Wasm code.
			//
			//
			// Note that the image must be accessible from the Envoy Gateway.
			image?: {
				// PullSecretRef is a reference to the secret containing the
				// credentials to pull the image.
				// Only support Kubernetes Secret resource from the same
				// namespace.
				pullSecretRef?: {
					// Group is the group of the referent. For example,
					// "gateway.networking.k8s.io".
					// When unspecified or empty string, core API group is inferred.
					group?: strings.MaxRunes(253) & =~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" | *""

					// Kind is kind of the referent. For example "Secret".
					kind?: strings.MaxRunes(63) & strings.MinRunes(1) & =~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$" | *"Secret"

					// Name is the name of the referent.
					name: strings.MaxRunes(253) & strings.MinRunes(1)

					// Namespace is the namespace of the referenced object. When
					// unspecified, the local
					// namespace is inferred.
					//
					//
					// Note that when a namespace different than the local namespace
					// is specified,
					// a ReferenceGrant object is required in the referent namespace
					// to allow that
					// namespace's owner to accept the reference. See the
					// ReferenceGrant
					// documentation for details.
					//
					//
					// Support: Core
					namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
						=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"
					}
				}

				// SHA256 checksum that will be used to verify the OCI image.
				//
				//
				// It must match the digest of the OCI image.
				//
				//
				// If not specified, Envoy Gateway will not verify the downloaded
				// OCI image.
				// kubebuilder:validation:Pattern=`^[a-f0-9]{64}$`
				sha256?: string

				// URL is the URL of the OCI image.
				// URL can be in the format of `registry/image:tag` or
				// `registry/image@sha256:digest`.
				url: string
			}

			// PullPolicy is the policy to use when pulling the Wasm module by
			// either the HTTP or Image source.
			// This field is only applicable when the SHA256 field is not set.
			//
			//
			// If not specified, the default policy is IfNotPresent except for
			// OCI images whose tag is latest.
			//
			//
			// Note: EG does not update the Wasm module every time an Envoy
			// proxy requests
			// the Wasm module even if the pull policy is set to Always.
			// It only updates the Wasm module when the EnvoyExtension
			// resource version changes.
			pullPolicy?: "IfNotPresent" | "Always"

			// Type is the type of the source of the Wasm code.
			// Valid WasmCodeSourceType values are "HTTP" or "Image".
			type: ("HTTP" | "Image") & ("HTTP" | "Image" | "ConfigMap")
		}

		// Config is the configuration for the Wasm extension.
		// This configuration will be passed as a JSON string to the Wasm
		// extension.
		config?: _

		// FailOpen is a switch used to control the behavior when a fatal
		// error occurs
		// during the initialization or the execution of the Wasm
		// extension.
		// If FailOpen is set to true, the system bypasses the Wasm
		// extension and
		// allows the traffic to pass through. Otherwise, if it is set to
		// false or
		// not set (defaulting to false), the system blocks the traffic
		// and returns
		// an HTTP 5xx error.
		failOpen?: bool | *false

		// Name is a unique name for this Wasm extension. It is used to
		// identify the
		// Wasm extension if multiple extensions are handled by the same
		// vm_id and root_id.
		// It's also used for logging/debugging.
		// If not specified, EG will generate a unique name for the Wasm
		// extension.
		name?: string

		// RootID is a unique ID for a set of extensions in a VM which
		// will share a
		// RootContext and Contexts if applicable (e.g., an Wasm
		// HttpFilter and an Wasm AccessLog).
		// If left blank, all extensions with a blank root_id with the
		// same vm_id will share Context(s).
		//
		//
		// Note: RootID must match the root_id parameter used to register
		// the Context in the Wasm code.
		rootID?: string
	}]
}
