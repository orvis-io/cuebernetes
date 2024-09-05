// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f crds.yaml

package v1alpha1

import (
	"strings"
	"list"
)

// SecurityPolicy allows the user to configure various security
// settings for a
// Gateway.
#SecurityPolicy: {
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
	kind: "SecurityPolicy"
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

	// Spec defines the desired state of SecurityPolicy.
	spec!: #SecurityPolicySpec
}

// Spec defines the desired state of SecurityPolicy.
#SecurityPolicySpec: {
	// Authorization defines the authorization configuration.
	authorization?: {
		// DefaultAction defines the default action to be taken if no
		// rules match.
		// If not specified, the default action is Deny.
		defaultAction?: "Allow" | "Deny"

		// Rules defines a list of authorization rules.
		// These rules are evaluated in order, the first matching rule
		// will be applied,
		// and the rest will be skipped.
		//
		//
		// For example, if there are two rules: the first rule allows the
		// request
		// and the second rule denies it, when a request matches both
		// rules, it will be allowed.
		rules?: [...{
			// Action defines the action to be taken if the rule matches.
			action: "Allow" | "Deny"

			// Name is a user-friendly name for the rule.
			// If not specified, Envoy Gateway will generate a unique name for
			// the rule.n
			name?: string
			principal: {
				// ClientCIDRs are the IP CIDR ranges of the client.
				// Valid examples are "192.168.1.0/24" or "2001:db8::/64"
				//
				//
				// The client IP is inferred from the X-Forwarded-For header, a
				// custom header,
				// or the proxy protocol.
				// You can use the `ClientIPDetection` or the
				// `EnableProxyProtocol` field in
				// the `ClientTrafficPolicy` to configure how the client IP is
				// detected.
				clientCIDRs: [...=~"((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\/([0-9]+))|((([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))\\/([0-9]+))"] & [_, ...]
			}
		}]
	}
	basicAuth?: {
		// The Kubernetes secret which contains the username-password
		// pairs in
		// htpasswd format, used to verify user credentials in the
		// "Authorization"
		// header.
		//
		//
		// This is an Opaque secret. The username-password pairs should be
		// stored in
		// the key ".htpasswd". As the key name indicates, the value needs
		// to be the
		// htpasswd format, for example:
		// "user1:{SHA}hashed_user1_password".
		// Right now, only SHA hash algorithm is supported.
		// Reference to
		// https://httpd.apache.org/docs/2.4/programs/htpasswd.html
		// for more details.
		//
		//
		// Note: The secret must be in the same namespace as the
		// SecurityPolicy.
		users: {
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
	}

	// CORS defines the configuration for Cross-Origin Resource
	// Sharing (CORS).
	cors?: {
		// AllowCredentials indicates whether a request can include user
		// credentials
		// like cookies, authentication headers, or TLS client
		// certificates.
		allowCredentials?: bool

		// AllowHeaders defines the headers that are allowed to be sent
		// with requests.
		allowHeaders?: [...string]

		// AllowMethods defines the methods that are allowed to make
		// requests.
		allowMethods?: [...string] & [_, ...]

		// AllowOrigins defines the origins that are allowed to make
		// requests.
		allowOrigins?: [...strings.MaxRunes(253) & strings.MinRunes(1) & =~"^(\\*|https?:\\/\\/(\\*|(\\*\\.)?(([\\w-]+\\.?)+)?[\\w-]+)(:\\d{1,5})?)$"] & [_, ...]

		// ExposeHeaders defines the headers that can be exposed in the
		// responses.
		exposeHeaders?: [...string]

		// MaxAge defines how long the results of a preflight request can
		// be cached.
		maxAge?: string
	}

	// ExtAuth defines the configuration for External Authorization.
	extAuth?: {
		// FailOpen is a switch used to control the behavior when a
		// response from the External Authorization service cannot be
		// obtained.
		// If FailOpen is set to true, the system allows the traffic to
		// pass through.
		// Otherwise, if it is set to false or not set (defaulting to
		// false),
		// the system blocks the traffic and returns a HTTP 5xx error,
		// reflecting a fail-closed approach.
		// This setting determines whether to prioritize accessibility
		// over strict security in case of authorization service failure.
		failOpen?: bool | *false

		// GRPC defines the gRPC External Authorization service.
		// Either GRPCService or HTTPService must be specified,
		// and only one of them can be provided.
		grpc?: {
			// BackendRef references a Kubernetes object that represents the
			// backend server to which the authorization request will be sent.
			// Only Service kind is supported for now.
			//
			//
			// Deprecated: Use BackendRefs instead.
			backendRef?: {
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
			}

			// BackendRefs references a Kubernetes object that represents the
			// backend server to which the authorization request will be sent.
			// Only Service kind is supported for now.
			backendRefs?: list.MaxItems(1) & [...{
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
			}]
		}

		// HeadersToExtAuth defines the client request headers that will
		// be included
		// in the request to the external authorization service.
		// Note: If not specified, the default behavior for gRPC and HTTP
		// external
		// authorization services is different due to backward
		// compatibility reasons.
		// All headers will be included in the check request to a gRPC
		// authorization server.
		// Only the following headers will be included in the check
		// request to an HTTP
		// authorization server: Host, Method, Path, Content-Length, and
		// Authorization.
		// And these headers will always be included to the check request
		// to an HTTP
		// authorization server by default, no matter whether they are
		// specified
		// in HeadersToExtAuth or not.
		headersToExtAuth?: [...string]

		// HTTP defines the HTTP External Authorization service.
		// Either GRPCService or HTTPService must be specified,
		// and only one of them can be provided.
		http?: {
			// BackendRef references a Kubernetes object that represents the
			// backend server to which the authorization request will be sent.
			// Only Service kind is supported for now.
			//
			//
			// Deprecated: Use BackendRefs instead.
			backendRef?: {
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
			}

			// BackendRefs references a Kubernetes object that represents the
			// backend server to which the authorization request will be sent.
			// Only Service kind is supported for now.
			backendRefs?: list.MaxItems(1) & [...{
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
			}]

			// HeadersToBackend are the authorization response headers that
			// will be added
			// to the original client request before sending it to the backend
			// server.
			// Note that coexisting headers will be overridden.
			// If not specified, no authorization response headers will be
			// added to the
			// original client request.
			headersToBackend?: [...string]

			// Path is the path of the HTTP External Authorization service.
			// If path is specified, the authorization request will be sent to
			// that path,
			// or else the authorization request will be sent to the root
			// path.
			path?: string
		}
	}

	// JWT defines the configuration for JSON Web Token (JWT)
	// authentication.
	jwt?: {
		// Optional determines whether a missing JWT is acceptable,
		// defaulting to false if not specified.
		// Note: Even if optional is set to true, JWT authentication will
		// still fail if an invalid JWT is presented.
		optional?: bool

		// Providers defines the JSON Web Token (JWT) authentication
		// provider type.
		// When multiple JWT providers are specified, the JWT is
		// considered valid if
		// any of the providers successfully validate the JWT. For
		// additional details,
		// see
		// https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/jwt_authn_filter.html.
		providers: list.MaxItems(4) & [...{
			// Audiences is a list of JWT audiences allowed access. For
			// additional details, see
			// https://tools.ietf.org/html/rfc7519#section-4.1.3. If not
			// provided, JWT audiences
			// are not checked.
			audiences?: list.MaxItems(8) & [...string]

			// ClaimToHeaders is a list of JWT claims that must be extracted
			// into HTTP request headers
			// For examples, following config:
			// The claim must be of type; string, int, double, bool. Array
			// type claims are not supported
			claimToHeaders?: [...{
				// Claim is the JWT Claim that should be saved into the header :
				// it can be a nested claim of type
				// (eg. "claim.nested.key", "sub"). The nested claim name must use
				// dot "."
				// to separate the JSON name path.
				claim: string

				// Header defines the name of the HTTP request header that the JWT
				// Claim will be saved into.
				header: string
			}]

			// ExtractFrom defines different ways to extract the JWT token
			// from HTTP request.
			// If empty, it defaults to extract JWT token from the
			// Authorization HTTP request header using Bearer schema
			// or access_token from query parameters.
			extractFrom?: {
				// Cookies represents a list of cookie names to extract the JWT
				// token from.
				cookies?: [...string]

				// Headers represents a list of HTTP request headers to extract
				// the JWT token from.
				headers?: [...{
					// Name is the HTTP header name to retrieve the token
					name: string

					// ValuePrefix is the prefix that should be stripped before
					// extracting the token.
					// The format would be used by Envoy like "{ValuePrefix}<TOKEN>".
					// For example, "Authorization: Bearer <TOKEN>", then the
					// ValuePrefix="Bearer " with a space at the end.
					valuePrefix?: string
				}]

				// Params represents a list of query parameters to extract the JWT
				// token from.
				params?: [...string]
			}

			// Issuer is the principal that issued the JWT and takes the form
			// of a URL or email address.
			// For additional details, see
			// https://tools.ietf.org/html/rfc7519#section-4.1.1 for
			// URL format and https://rfc-editor.org/rfc/rfc5322.html for
			// email format. If not provided,
			// the JWT issuer is not checked.
			issuer?: strings.MaxRunes(253)

			// Name defines a unique name for the JWT provider. A name can
			// have a variety of forms,
			// including RFC1123 subdomains, RFC 1123 labels, or RFC 1035
			// labels.
			name: strings.MaxRunes(253) & strings.MinRunes(1)

			// RecomputeRoute clears the route cache and recalculates the
			// routing decision.
			// This field must be enabled if the headers generated from the
			// claim are used for
			// route matching decisions. If the recomputation selects a new
			// route, features targeting
			// the new matched route will be applied.
			recomputeRoute?: bool
			remoteJWKS: {
				// URI is the HTTPS URI to fetch the JWKS. Envoy's system trust
				// bundle is used to
				// validate the server certificate.
				uri: strings.MaxRunes(253) & strings.MinRunes(1)
			}
		}] & [_, ...]
	}

	// OIDC defines the configuration for the OpenID Connect (OIDC)
	// authentication.
	oidc?: {
		// The client ID to be used in the OIDC
		// [Authentication
		// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
		clientID: strings.MinRunes(1)

		// The Kubernetes secret which contains the OIDC client secret to
		// be used in the
		// [Authentication
		// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
		//
		//
		// This is an Opaque secret. The client secret should be stored in
		// the key
		// "client-secret".
		clientSecret: {
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

		// The optional cookie name overrides to be used for Bearer and
		// IdToken cookies in the
		// [Authentication
		// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
		// If not specified, uses a randomly generated suffix
		cookieNames?: {
			// The name of the cookie used to store the AccessToken in the
			// [Authentication
			// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
			// If not specified, defaults to "AccessToken-(randomly generated
			// uid)"
			accessToken?: string

			// The name of the cookie used to store the IdToken in the
			// [Authentication
			// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
			// If not specified, defaults to "IdToken-(randomly generated
			// uid)"
			idToken?: string
		}

		// DefaultRefreshTokenTTL is the default lifetime of the refresh
		// token.
		// This field is only used when the exp (expiration time) claim is
		// omitted in
		// the refresh token or the refresh token is not JWT.
		//
		//
		// If not specified, defaults to 604800s (one week).
		// Note: this field is only applicable when the "refreshToken"
		// field is set to true.
		defaultRefreshTokenTTL?: string

		// DefaultTokenTTL is the default lifetime of the id token and
		// access token.
		// Please note that Envoy will always use the expiry time from the
		// response
		// of the authorization server if it is provided. This field is
		// only used when
		// the expiry time is not provided by the authorization.
		//
		//
		// If not specified, defaults to 0. In this case, the "expires_in"
		// field in
		// the authorization response must be set by the authorization
		// server, or the
		// OAuth flow will fail.
		defaultTokenTTL?: string

		// ForwardAccessToken indicates whether the Envoy should forward
		// the access token
		// via the Authorization header Bearer scheme to the upstream.
		// If not specified, defaults to false.
		forwardAccessToken?: bool

		// The path to log a user out, clearing their credential cookies.
		//
		//
		// If not specified, uses a default logout path "/logout"
		logoutPath?: string

		// The OIDC Provider configuration.
		provider: {
			// The OIDC Provider's [authorization
			// endpoint](https://openid.net/specs/openid-connect-core-1_0.html#AuthorizationEndpoint).
			// If not provided, EG will try to discover it from the provider's
			// [Well-Known Configuration
			// Endpoint](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfigurationResponse).
			authorizationEndpoint?: string

			// The OIDC Provider's [issuer
			// identifier](https://openid.net/specs/openid-connect-discovery-1_0.html#IssuerDiscovery).
			// Issuer MUST be a URI RFC 3986 [RFC3986] with a scheme component
			// that MUST
			// be https, a host component, and optionally, port and path
			// components and
			// no query or fragment components.
			issuer: strings.MinRunes(1)

			// The OIDC Provider's [token
			// endpoint](https://openid.net/specs/openid-connect-core-1_0.html#TokenEndpoint).
			// If not provided, EG will try to discover it from the provider's
			// [Well-Known Configuration
			// Endpoint](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfigurationResponse).
			tokenEndpoint?: string
		}

		// The redirect URL to be used in the OIDC
		// [Authentication
		// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
		// If not specified, uses the default redirect URI
		// "%REQ(x-forwarded-proto)%://%REQ(:authority)%/oauth2/callback"
		redirectURL?: string

		// RefreshToken indicates whether the Envoy should automatically
		// refresh the
		// id token and access token when they expire.
		// When set to true, the Envoy will use the refresh token to get a
		// new id token
		// and access token when they expire.
		//
		//
		// If not specified, defaults to false.
		refreshToken?: bool

		// The OIDC resources to be used in the
		// [Authentication
		// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
		resources?: [...string]

		// The OIDC scopes to be used in the
		// [Authentication
		// Request](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest).
		// The "openid" scope is always added to the list of scopes if not
		// already
		// specified.
		scopes?: [...string]
	}

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
}
