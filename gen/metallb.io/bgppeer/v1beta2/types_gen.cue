// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml

package v1beta2

import "strings"

// BGPPeer is the Schema for the peers API.
#BGPPeer: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "metallb.io/v1beta2"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "BGPPeer"
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

	// BGPPeerSpec defines the desired state of Peer.
	spec!: #BGPPeerSpec
}

// BGPPeerSpec defines the desired state of Peer.
#BGPPeerSpec: {
	// The name of the BFD Profile to be used for the BFD session
	// associated to the BGP session. If not set, the BFD session
	// won't be set up.
	bfdProfile?: string

	// Requested BGP connect time, controls how long BGP waits between
	// connection attempts to a neighbor.
	connectTime?: string

	// To set if we want to disable MP BGP that will separate IPv4 and
	// IPv6 route exchanges into distinct BGP sessions.
	disableMP?: bool | *false

	// To set if the BGPPeer is multi-hops away. Needed for FRR mode
	// only.
	ebgpMultiHop?: bool

	// EnableGracefulRestart allows BGP peer to continue to forward
	// data packets along
	// known routes while the routing protocol information is being
	// restored.
	// This field is immutable because it requires restart of the BGP
	// session
	// Supported for FRR mode only.
	enableGracefulRestart?: bool

	// Requested BGP hold time, per RFC4271.
	holdTime?: string

	// Requested BGP keepalive time, per RFC4271.
	keepaliveTime?: string

	// AS number to use for the local end of the session.
	myASN: uint32

	// Only connect to this peer on nodes that match one of these
	// selectors.
	nodeSelectors?: [...{
		// matchExpressions is a list of label selector requirements. The
		// requirements are ANDed.
		matchExpressions?: [...{
			// key is the label key that the selector applies to.
			key: string

			// operator represents a key's relationship to a set of values.
			// Valid operators are In, NotIn, Exists and DoesNotExist.
			operator: string

			// values is an array of string values. If the operator is In or
			// NotIn,
			// the values array must be non-empty. If the operator is Exists
			// or DoesNotExist,
			// the values array must be empty. This array is replaced during a
			// strategic
			// merge patch.
			values?: [...string]
		}]

		// matchLabels is a map of {key,value} pairs. A single {key,value}
		// in the matchLabels
		// map is equivalent to an element of matchExpressions, whose key
		// field is "key", the
		// operator is "In", and the values array contains only "value".
		// The requirements are ANDed.
		matchLabels?: {
			[string]: string
		}
	}]

	// Authentication password for routers enforcing TCP MD5
	// authenticated sessions
	password?: string

	// passwordSecret is name of the authentication secret for BGP
	// Peer.
	// the secret must be of type "kubernetes.io/basic-auth", and
	// created in the
	// same namespace as the MetalLB deployment. The password is
	// stored in the
	// secret as the key "password".
	passwordSecret?: {
		// name is unique within a namespace to reference a secret
		// resource.
		name?: string

		// namespace defines the space within which the secret name must
		// be unique.
		namespace?: string
	}

	// AS number to expect from the remote end of the session.
	peerASN: uint32

	// Address to dial when establishing the session.
	peerAddress: string

	// Port to dial when establishing the session.
	peerPort?: int & <=16384 & >=0 | *179

	// BGP router ID to advertise to the peer
	routerID?: string

	// Source address to use when establishing the session.
	sourceAddress?: string

	// To set if we want to peer with the BGPPeer using an interface
	// belonging to
	// a host vrf
	vrf?: string
}
