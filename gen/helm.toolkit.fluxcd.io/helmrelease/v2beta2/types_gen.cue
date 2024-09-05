// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

package v2beta2

import "strings"

// HelmRelease is the Schema for the helmreleases API
#HelmRelease: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "helm.toolkit.fluxcd.io/v2beta2"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "HelmRelease"
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

	// HelmReleaseSpec defines the desired state of a Helm release.
	spec!: #HelmReleaseSpec
}

// HelmReleaseSpec defines the desired state of a Helm release.
#HelmReleaseSpec: {
	// Chart defines the template of the v1beta2.HelmChart that should
	// be created
	// for this HelmRelease.
	chart?: {
		// ObjectMeta holds the template for metadata like labels and
		// annotations.
		metadata?: {
			// Annotations is an unstructured key value map stored with a
			// resource that may be
			// set by external tools to store and retrieve arbitrary metadata.
			// They are not
			// queryable and should be preserved when modifying objects.
			// More info:
			// https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
			annotations?: {
				[string]: string
			}

			// Map of string keys and values that can be used to organize and
			// categorize
			// (scope and select) objects.
			// More info:
			// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
			labels?: {
				[string]: string
			}
		}

		// Spec holds the template for the v1beta2.HelmChartSpec for this
		// HelmRelease.
		spec: {
			// The name or path the Helm chart is available at in the
			// SourceRef.
			chart: strings.MaxRunes(2048) & strings.MinRunes(1)

			// IgnoreMissingValuesFiles controls whether to silently ignore
			// missing values files rather than failing.
			ignoreMissingValuesFiles?: bool

			// Interval at which to check the v1.Source for updates. Defaults
			// to
			// 'HelmReleaseSpec.Interval'.
			interval?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"

			// Determines what enables the creation of a new artifact. Valid
			// values are
			// ('ChartVersion', 'Revision').
			// See the documentation of the values for an explanation on their
			// behavior.
			// Defaults to ChartVersion when omitted.
			reconcileStrategy?: "ChartVersion" | "Revision" | *"ChartVersion"

			// The name and namespace of the v1.Source the chart is available
			// at.
			sourceRef: {
				// APIVersion of the referent.
				apiVersion?: string

				// Kind of the referent.
				kind?: "HelmRepository" | "GitRepository" | "Bucket"

				// Name of the referent.
				name: strings.MaxRunes(253) & strings.MinRunes(1)

				// Namespace of the referent.
				namespace?: strings.MaxRunes(63) & strings.MinRunes(1)
			}

			// Alternative values file to use as the default chart values,
			// expected to
			// be a relative path in the SourceRef. Deprecated in favor of
			// ValuesFiles,
			// for backwards compatibility the file defined here is merged
			// before the
			// ValuesFiles items. Ignored when omitted.
			valuesFile?: string

			// Alternative list of values files to use as the chart values
			// (values.yaml
			// is not included by default), expected to be a relative path in
			// the SourceRef.
			// Values files are merged in the order of this list with the last
			// file overriding
			// the first. Ignored when omitted.
			valuesFiles?: [...string]

			// Verify contains the secret name containing the trusted public
			// keys
			// used to verify the signature and specifies which provider to
			// use to check
			// whether OCI image is authentic.
			// This field is only supported for OCI sources.
			// Chart dependencies, which are not bundled in the umbrella chart
			// artifact,
			// are not verified.
			verify?: {
				// Provider specifies the technology used to sign the OCI Helm
				// chart.
				provider: "cosign" | "notation" | *"cosign"
				secretRef?: {
					// Name of the referent.
					name: string
				}
			}

			// Version semver expression, ignored for charts from
			// v1beta2.GitRepository and
			// v1beta2.Bucket sources. Defaults to latest when omitted.
			version?: string | *"*"
		}
	}

	// ChartRef holds a reference to a source controller resource
	// containing the
	// Helm chart artifact.
	//
	//
	// Note: this field is provisional to the v2 API, and not actively
	// used
	// by v2beta2 HelmReleases.
	chartRef?: {
		// APIVersion of the referent.
		apiVersion?: string

		// Kind of the referent.
		kind: "OCIRepository" | "HelmChart"

		// Name of the referent.
		name: strings.MaxRunes(253) & strings.MinRunes(1)

		// Namespace of the referent, defaults to the namespace of the
		// Kubernetes
		// resource object that contains the reference.
		namespace?: strings.MaxRunes(63) & strings.MinRunes(1)
	}

	// DependsOn may contain a meta.NamespacedObjectReference slice
	// with
	// references to HelmRelease resources that must be ready before
	// this HelmRelease
	// can be reconciled.
	dependsOn?: [...{
		// Name of the referent.
		name: string

		// Namespace of the referent, when not specified it acts as
		// LocalObjectReference.
		namespace?: string
	}]

	// DriftDetection holds the configuration for detecting and
	// handling
	// differences between the manifest in the Helm storage and the
	// resources
	// currently existing in the cluster.
	driftDetection?: {
		// Ignore contains a list of rules for specifying which changes to
		// ignore
		// during diffing.
		ignore?: [...{
			// Paths is a list of JSON Pointer (RFC 6901) paths to be excluded
			// from
			// consideration in a Kubernetes object.
			paths: [...string]

			// Target is a selector for specifying Kubernetes objects to which
			// this
			// rule applies.
			// If Target is not set, the Paths will be ignored for all
			// Kubernetes
			// objects within the manifest of the Helm release.
			target?: {
				// AnnotationSelector is a string that follows the label selection
				// expression
				// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api
				// It matches with the resource annotations.
				annotationSelector?: string

				// Group is the API group to select resources from.
				// Together with Version and Kind it is capable of unambiguously
				// identifying and/or selecting resources.
				// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
				group?: string

				// Kind of the API Group to select resources from.
				// Together with Group and Version it is capable of unambiguously
				// identifying and/or selecting resources.
				// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
				kind?: string

				// LabelSelector is a string that follows the label selection
				// expression
				// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api
				// It matches with the resource labels.
				labelSelector?: string

				// Name to match resources with.
				name?: string

				// Namespace to select resources from.
				namespace?: string

				// Version of the API Group to select resources from.
				// Together with Group and Kind it is capable of unambiguously
				// identifying and/or selecting resources.
				// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
				version?: string
			}
		}]

		// Mode defines how differences should be handled between the Helm
		// manifest
		// and the manifest currently applied to the cluster.
		// If not explicitly set, it defaults to DiffModeDisabled.
		mode?: "enabled" | "warn" | "disabled"
	}

	// Install holds the configuration for Helm install actions for
	// this HelmRelease.
	install?: {
		// CRDs upgrade CRDs from the Helm Chart's crds directory
		// according
		// to the CRD upgrade policy provided here. Valid values are
		// `Skip`,
		// `Create` or `CreateReplace`. Default is `Create` and if omitted
		// CRDs are installed but not updated.
		//
		//
		// Skip: do neither install nor replace (update) any CRDs.
		//
		//
		// Create: new CRDs are created, existing CRDs are neither updated
		// nor deleted.
		//
		//
		// CreateReplace: new CRDs are created, existing CRDs are updated
		// (replaced)
		// but not deleted.
		//
		//
		// By default, CRDs are applied (installed) during Helm install
		// action.
		// With this option users can opt in to CRD replace existing CRDs
		// on Helm
		// install actions, which is not (yet) natively supported by Helm.
		// https://helm.sh/docs/chart_best_practices/custom_resource_definitions.
		crds?: "Skip" | "Create" | "CreateReplace"

		// CreateNamespace tells the Helm install action to create the
		// HelmReleaseSpec.TargetNamespace if it does not exist yet.
		// On uninstall, the namespace will not be garbage collected.
		createNamespace?: bool

		// DisableHooks prevents hooks from running during the Helm
		// install action.
		disableHooks?: bool

		// DisableOpenAPIValidation prevents the Helm install action from
		// validating
		// rendered templates against the Kubernetes OpenAPI Schema.
		disableOpenAPIValidation?: bool

		// DisableWait disables the waiting for resources to be ready
		// after a Helm
		// install has been performed.
		disableWait?: bool

		// DisableWaitForJobs disables waiting for jobs to complete after
		// a Helm
		// install has been performed.
		disableWaitForJobs?: bool

		// Remediation holds the remediation configuration for when the
		// Helm install
		// action for the HelmRelease fails. The default is to not perform
		// any action.
		remediation?: {
			// IgnoreTestFailures tells the controller to skip remediation
			// when the Helm
			// tests are run after an install action but fail. Defaults to
			// 'Test.IgnoreFailures'.
			ignoreTestFailures?: bool

			// RemediateLastFailure tells the controller to remediate the last
			// failure, when
			// no retries remain. Defaults to 'false'.
			remediateLastFailure?: bool

			// Retries is the number of retries that should be attempted on
			// failures before
			// bailing. Remediation, using an uninstall, is performed between
			// each attempt.
			// Defaults to '0', a negative integer equals to unlimited
			// retries.
			retries?: int
		}

		// Replace tells the Helm install action to re-use the
		// 'ReleaseName', but only
		// if that name is a deleted release which remains in the history.
		replace?: bool

		// SkipCRDs tells the Helm install action to not install any CRDs.
		// By default,
		// CRDs are installed if not already present.
		//
		//
		// Deprecated use CRD policy (`crds`) attribute with value `Skip`
		// instead.
		skipCRDs?: bool

		// Timeout is the time to wait for any individual Kubernetes
		// operation (like
		// Jobs for hooks) during the performance of a Helm install
		// action. Defaults to
		// 'HelmReleaseSpec.Timeout'.
		timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	}

	// Interval at which to reconcile the Helm release.
	interval: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	kubeConfig?: {
		// SecretRef holds the name of a secret that contains a key with
		// the kubeconfig file as the value. If no key is set, the key
		// will default
		// to 'value'.
		// It is recommended that the kubeconfig is self-contained, and
		// the secret
		// is regularly updated if credentials such as a
		// cloud-access-token expire.
		// Cloud specific `cmd-path` auth helpers will not function
		// without adding
		// binaries and credentials to the Pod that is responsible for
		// reconciling
		// Kubernetes resources.
		secretRef: {
			// Key in the Secret, when not specified an
			// implementation-specific default key is used.
			key?: string

			// Name of the Secret.
			name: string
		}
	}

	// MaxHistory is the number of revisions saved by Helm for this
	// HelmRelease.
	// Use '0' for an unlimited number of revisions; defaults to '5'.
	maxHistory?: int

	// PersistentClient tells the controller to use a persistent
	// Kubernetes
	// client for this release. When enabled, the client will be
	// reused for the
	// duration of the reconciliation, instead of being created and
	// destroyed
	// for each (step of a) Helm action.
	//
	//
	// This can improve performance, but may cause issues with some
	// Helm charts
	// that for example do create Custom Resource Definitions during
	// installation
	// outside Helm's CRD lifecycle hooks, which are then not observed
	// to be
	// available by e.g. post-install hooks.
	//
	//
	// If not set, it defaults to true.
	persistentClient?: bool

	// PostRenderers holds an array of Helm PostRenderers, which will
	// be applied in order
	// of their definition.
	postRenderers?: [...{
		// Kustomization to apply as PostRenderer.
		kustomize?: {
			// Images is a list of (image name, new name, new tag or digest)
			// for changing image names, tags or digests. This can also be
			// achieved with a
			// patch, but this operator is simpler to specify.
			images?: [...{
				// Digest is the value used to replace the original image tag.
				// If digest is present NewTag value is ignored.
				digest?: string

				// Name is a tag-less image name.
				name: string

				// NewName is the value used to replace the original name.
				newName?: string

				// NewTag is the value used to replace the original tag.
				newTag?: string
			}]

			// Strategic merge and JSON patches, defined as inline YAML
			// objects,
			// capable of targeting objects based on kind, label and
			// annotation selectors.
			patches?: [...{
				// Patch contains an inline StrategicMerge patch or an inline
				// JSON6902 patch with
				// an array of operation objects.
				patch: string

				// Target points to the resources that the patch document should
				// be applied to.
				target?: {
					// AnnotationSelector is a string that follows the label selection
					// expression
					// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api
					// It matches with the resource annotations.
					annotationSelector?: string

					// Group is the API group to select resources from.
					// Together with Version and Kind it is capable of unambiguously
					// identifying and/or selecting resources.
					// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
					group?: string

					// Kind of the API Group to select resources from.
					// Together with Group and Version it is capable of unambiguously
					// identifying and/or selecting resources.
					// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
					kind?: string

					// LabelSelector is a string that follows the label selection
					// expression
					// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api
					// It matches with the resource labels.
					labelSelector?: string

					// Name to match resources with.
					name?: string

					// Namespace to select resources from.
					namespace?: string

					// Version of the API Group to select resources from.
					// Together with Group and Kind it is capable of unambiguously
					// identifying and/or selecting resources.
					// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
					version?: string
				}
			}]

			// JSON 6902 patches, defined as inline YAML objects.
			// Deprecated: use Patches instead.
			patchesJson6902?: [...{
				// Patch contains the JSON6902 patch document with an array of
				// operation objects.
				patch: [...{
					// From contains a JSON-pointer value that references a location
					// within the target document where the operation is
					// performed. The meaning of the value depends on the value of Op,
					// and is NOT taken into account by all operations.
					from?: string

					// Op indicates the operation to perform. Its value MUST be one of
					// "add", "remove", "replace", "move", "copy", or
					// "test".
					// https://datatracker.ietf.org/doc/html/rfc6902#section-4
					op: "test" | "remove" | "add" | "replace" | "move" | "copy"

					// Path contains the JSON-pointer value that references a location
					// within the target document where the operation
					// is performed. The meaning of the value depends on the value of
					// Op.
					path: string

					// Value contains a valid JSON structure. The meaning of the value
					// depends on the value of Op, and is NOT taken into
					// account by all operations.
					value?: _
				}]

				// Target points to the resources that the patch document should
				// be applied to.
				target: {
					// AnnotationSelector is a string that follows the label selection
					// expression
					// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api
					// It matches with the resource annotations.
					annotationSelector?: string

					// Group is the API group to select resources from.
					// Together with Version and Kind it is capable of unambiguously
					// identifying and/or selecting resources.
					// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
					group?: string

					// Kind of the API Group to select resources from.
					// Together with Group and Version it is capable of unambiguously
					// identifying and/or selecting resources.
					// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
					kind?: string

					// LabelSelector is a string that follows the label selection
					// expression
					// https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api
					// It matches with the resource labels.
					labelSelector?: string

					// Name to match resources with.
					name?: string

					// Namespace to select resources from.
					namespace?: string

					// Version of the API Group to select resources from.
					// Together with Group and Kind it is capable of unambiguously
					// identifying and/or selecting resources.
					// https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md
					version?: string
				}
			}]

			// Strategic merge patches, defined as inline YAML objects.
			// Deprecated: use Patches instead.
			patchesStrategicMerge?: [...]
		}
	}]

	// ReleaseName used for the Helm release. Defaults to a
	// composition of
	// '[TargetNamespace-]Name'.
	releaseName?: strings.MaxRunes(53) & strings.MinRunes(1)

	// Rollback holds the configuration for Helm rollback actions for
	// this HelmRelease.
	rollback?: {
		// CleanupOnFail allows deletion of new resources created during
		// the Helm
		// rollback action when it fails.
		cleanupOnFail?: bool

		// DisableHooks prevents hooks from running during the Helm
		// rollback action.
		disableHooks?: bool

		// DisableWait disables the waiting for resources to be ready
		// after a Helm
		// rollback has been performed.
		disableWait?: bool

		// DisableWaitForJobs disables waiting for jobs to complete after
		// a Helm
		// rollback has been performed.
		disableWaitForJobs?: bool

		// Force forces resource updates through a replacement strategy.
		force?: bool

		// Recreate performs pod restarts for the resource if applicable.
		recreate?: bool

		// Timeout is the time to wait for any individual Kubernetes
		// operation (like
		// Jobs for hooks) during the performance of a Helm rollback
		// action. Defaults to
		// 'HelmReleaseSpec.Timeout'.
		timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	}

	// The name of the Kubernetes service account to impersonate
	// when reconciling this HelmRelease.
	serviceAccountName?: strings.MaxRunes(253) & strings.MinRunes(1)

	// StorageNamespace used for the Helm storage.
	// Defaults to the namespace of the HelmRelease.
	storageNamespace?: strings.MaxRunes(63) & strings.MinRunes(1)

	// Suspend tells the controller to suspend reconciliation for this
	// HelmRelease,
	// it does not apply to already started reconciliations. Defaults
	// to false.
	suspend?: bool

	// TargetNamespace to target when performing operations for the
	// HelmRelease.
	// Defaults to the namespace of the HelmRelease.
	targetNamespace?: strings.MaxRunes(63) & strings.MinRunes(1)

	// Test holds the configuration for Helm test actions for this
	// HelmRelease.
	test?: {
		// Enable enables Helm test actions for this HelmRelease after an
		// Helm install
		// or upgrade action has been performed.
		enable?: bool

		// Filters is a list of tests to run or exclude from running.
		filters?: [...{
			// Exclude specifies whether the named test should be excluded.
			exclude?: bool

			// Name is the name of the test.
			name: strings.MaxRunes(253) & strings.MinRunes(1)
		}]

		// IgnoreFailures tells the controller to skip remediation when
		// the Helm tests
		// are run but fail. Can be overwritten for tests run after
		// install or upgrade
		// actions in 'Install.IgnoreTestFailures' and
		// 'Upgrade.IgnoreTestFailures'.
		ignoreFailures?: bool

		// Timeout is the time to wait for any individual Kubernetes
		// operation during
		// the performance of a Helm test action. Defaults to
		// 'HelmReleaseSpec.Timeout'.
		timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	}

	// Timeout is the time to wait for any individual Kubernetes
	// operation (like Jobs
	// for hooks) during the performance of a Helm action. Defaults to
	// '5m0s'.
	timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"

	// Uninstall holds the configuration for Helm uninstall actions
	// for this HelmRelease.
	uninstall?: {
		// DeletionPropagation specifies the deletion propagation policy
		// when
		// a Helm uninstall is performed.
		deletionPropagation?: "background" | "foreground" | "orphan" | *"background"

		// DisableHooks prevents hooks from running during the Helm
		// rollback action.
		disableHooks?: bool

		// DisableWait disables waiting for all the resources to be
		// deleted after
		// a Helm uninstall is performed.
		disableWait?: bool

		// KeepHistory tells Helm to remove all associated resources and
		// mark the
		// release as deleted, but retain the release history.
		keepHistory?: bool

		// Timeout is the time to wait for any individual Kubernetes
		// operation (like
		// Jobs for hooks) during the performance of a Helm uninstall
		// action. Defaults
		// to 'HelmReleaseSpec.Timeout'.
		timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	}

	// Upgrade holds the configuration for Helm upgrade actions for
	// this HelmRelease.
	upgrade?: {
		// CleanupOnFail allows deletion of new resources created during
		// the Helm
		// upgrade action when it fails.
		cleanupOnFail?: bool

		// CRDs upgrade CRDs from the Helm Chart's crds directory
		// according
		// to the CRD upgrade policy provided here. Valid values are
		// `Skip`,
		// `Create` or `CreateReplace`. Default is `Skip` and if omitted
		// CRDs are neither installed nor upgraded.
		//
		//
		// Skip: do neither install nor replace (update) any CRDs.
		//
		//
		// Create: new CRDs are created, existing CRDs are neither updated
		// nor deleted.
		//
		//
		// CreateReplace: new CRDs are created, existing CRDs are updated
		// (replaced)
		// but not deleted.
		//
		//
		// By default, CRDs are not applied during Helm upgrade action.
		// With this
		// option users can opt-in to CRD upgrade, which is not (yet)
		// natively supported by Helm.
		// https://helm.sh/docs/chart_best_practices/custom_resource_definitions.
		crds?: "Skip" | "Create" | "CreateReplace"

		// DisableHooks prevents hooks from running during the Helm
		// upgrade action.
		disableHooks?: bool

		// DisableOpenAPIValidation prevents the Helm upgrade action from
		// validating
		// rendered templates against the Kubernetes OpenAPI Schema.
		disableOpenAPIValidation?: bool

		// DisableWait disables the waiting for resources to be ready
		// after a Helm
		// upgrade has been performed.
		disableWait?: bool

		// DisableWaitForJobs disables waiting for jobs to complete after
		// a Helm
		// upgrade has been performed.
		disableWaitForJobs?: bool

		// Force forces resource updates through a replacement strategy.
		force?: bool

		// PreserveValues will make Helm reuse the last release's values
		// and merge in
		// overrides from 'Values'. Setting this flag makes the
		// HelmRelease
		// non-declarative.
		preserveValues?: bool

		// Remediation holds the remediation configuration for when the
		// Helm upgrade
		// action for the HelmRelease fails. The default is to not perform
		// any action.
		remediation?: {
			// IgnoreTestFailures tells the controller to skip remediation
			// when the Helm
			// tests are run after an upgrade action but fail.
			// Defaults to 'Test.IgnoreFailures'.
			ignoreTestFailures?: bool

			// RemediateLastFailure tells the controller to remediate the last
			// failure, when
			// no retries remain. Defaults to 'false' unless 'Retries' is
			// greater than 0.
			remediateLastFailure?: bool

			// Retries is the number of retries that should be attempted on
			// failures before
			// bailing. Remediation, using 'Strategy', is performed between
			// each attempt.
			// Defaults to '0', a negative integer equals to unlimited
			// retries.
			retries?: int

			// Strategy to use for failure remediation. Defaults to
			// 'rollback'.
			strategy?: "rollback" | "uninstall"
		}

		// Timeout is the time to wait for any individual Kubernetes
		// operation (like
		// Jobs for hooks) during the performance of a Helm upgrade
		// action. Defaults to
		// 'HelmReleaseSpec.Timeout'.
		timeout?: =~"^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
	}

	// Values holds the values for this Helm release.
	values?: _

	// ValuesFrom holds references to resources containing Helm values
	// for this HelmRelease,
	// and information about how they should be merged.
	valuesFrom?: [...{
		// Kind of the values referent, valid values are ('Secret',
		// 'ConfigMap').
		kind: "Secret" | "ConfigMap"

		// Name of the values referent. Should reside in the same
		// namespace as the
		// referring resource.
		name: strings.MaxRunes(253) & strings.MinRunes(1)

		// Optional marks this ValuesReference as optional. When set, a
		// not found error
		// for the values reference is ignored, but any ValuesKey,
		// TargetPath or
		// transient error will still result in a reconciliation failure.
		optional?: bool

		// TargetPath is the YAML dot notation path the value should be
		// merged at. When
		// set, the ValuesKey is expected to be a single flat value.
		// Defaults to 'None',
		// which results in the values getting merged at the root.
		targetPath?: strings.MaxRunes(250) & {
			=~"^([a-zA-Z0-9_\\-.\\\\\\/]|\\[[0-9]{1,5}\\])+$"
		}

		// ValuesKey is the data key where the values.yaml or a specific
		// value can be
		// found at. Defaults to 'values.yaml'.
		valuesKey?: strings.MaxRunes(253) & {
			=~"^[\\-._a-zA-Z0-9]+$"
		}
	}]
}
