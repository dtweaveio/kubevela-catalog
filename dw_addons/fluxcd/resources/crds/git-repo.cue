package main

gitRepoCRD: {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.12.0"
		labels: {
			"app.kubernetes.io/component": "source-controller"
			"app.kubernetes.io/instance":  "flux-system"
			"app.kubernetes.io/part-of":   "flux"
			"app.kubernetes.io/version":   "v2.1.0"
		}
		name: "gitrepositories.source.toolkit.fluxcd.io"
	}
	spec: {
		group: "source.toolkit.fluxcd.io"
		names: {
			kind:     "GitRepository"
			listKind: "GitRepositoryList"
			plural:   "gitrepositories"
			shortNames: [
				"gitrepo",
			]
			singular: "gitrepository"
		}
		scope: "Namespaced"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".spec.url"
				name:     "URL"
				type:     "string"
			}, {
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			name: "v1"
			schema: openAPIV3Schema: {
				description: "GitRepository is the Schema for the gitrepositories API."
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "GitRepositorySpec specifies the required configuration to produce an Artifact for a Git repository."

						properties: {
							ignore: {
								description: "Ignore overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default will be used, consult the documentation for your version to find out what those are."

								type: "string"
							}
							include: {
								description: "Include specifies a list of GitRepository resources which Artifacts should be included in the Artifact produced for this GitRepository."

								items: {
									description: "GitRepositoryInclude specifies a local reference to a GitRepository which Artifact (sub-)contents must be included, and where they should be placed."

									properties: {
										fromPath: {
											description: "FromPath specifies the path to copy contents from, defaults to the root of the Artifact."

											type: "string"
										}
										repository: {
											description: "GitRepositoryRef specifies the GitRepository which Artifact contents must be included."

											properties: name: {
												description: "Name of the referent."
												type:        "string"
											}
											required: [
												"name",
											]
											type: "object"
										}
										toPath: {
											description: "ToPath specifies the path to copy contents to, defaults to the name of the GitRepositoryRef."

											type: "string"
										}
									}
									required: [
										"repository",
									]
									type: "object"
								}
								type: "array"
							}
							interval: {
								description: "Interval at which the GitRepository URL is checked for updates. This interval is approximate and may be subject to jitter to ensure efficient use of resources."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:    "string"
							}
							proxySecretRef: {
								description: "ProxySecretRef specifies the Secret containing the proxy configuration to use while communicating with the Git server."

								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: [
									"name",
								]
								type: "object"
							}
							recurseSubmodules: {
								description: "RecurseSubmodules enables the initialization of all submodules within the GitRepository as cloned from the URL, using their default settings."

								type: "boolean"
							}
							ref: {
								description: "Reference specifies the Git reference to resolve and monitor for changes, defaults to the 'master' branch."

								properties: {
									branch: {
										description: "Branch to check out, defaults to 'master' if no other field is defined."

										type: "string"
									}
									commit: {
										description: """
			Commit SHA to check out, takes precedence over all reference fields. 
			 This can be combined with Branch to shallow clone the branch, in which the commit is expected to exist.
			"""

										type: "string"
									}
									name: {
										description: """
			Name of the reference to check out; takes precedence over Branch, Tag and SemVer. 
			 It must be a valid Git reference: https://git-scm.com/docs/git-check-ref-format#_description Examples: \"refs/heads/main\", \"refs/tags/v0.1.0\", \"refs/pull/420/head\", \"refs/merge-requests/1/head\"
			"""

										type: "string"
									}
									semver: {
										description: "SemVer tag expression to check out, takes precedence over Tag."

										type: "string"
									}
									tag: {
										description: "Tag to check out, takes precedence over Branch."
										type:        "string"
									}
								}
								type: "object"
							}
							secretRef: {
								description: "SecretRef specifies the Secret containing authentication credentials for the GitRepository. For HTTPS repositories the Secret must contain 'username' and 'password' fields for basic auth or 'bearerToken' field for token auth. For SSH repositories the Secret must contain 'identity' and 'known_hosts' fields."

								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: [
									"name",
								]
								type: "object"
							}
							suspend: {
								description: "Suspend tells the controller to suspend the reconciliation of this GitRepository."

								type: "boolean"
							}
							timeout: {
								default:     "60s"
								description: "Timeout for Git operations like cloning, defaults to 60s."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m))+$"
								type:    "string"
							}
							url: {
								description: "URL specifies the Git repository URL, it can be an HTTP/S or SSH address."

								pattern: "^(http|https|ssh)://.*$"
								type:    "string"
							}
							verify: {
								description: "Verification specifies the configuration to verify the Git commit signature(s)."

								properties: {
									mode: {
										default: "HEAD"
										description: """
			Mode specifies which Git object(s) should be verified. 
			 The variants \"head\" and \"HEAD\" both imply the same thing, i.e. verify the commit that the HEAD of the Git repository points to. The variant \"head\" solely exists to ensure backwards compatibility.
			"""

										enum: [
											"head",
											"HEAD",
											"Tag",
											"TagAndHEAD",
										]
										type: "string"
									}
									secretRef: {
										description: "SecretRef specifies the Secret containing the public keys of trusted Git authors."

										properties: name: {
											description: "Name of the referent."
											type:        "string"
										}
										required: [
											"name",
										]
										type: "object"
									}
								}
								required: [
									"secretRef",
								]
								type: "object"
							}
						}
						required: [
							"interval",
							"url",
						]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "GitRepositoryStatus records the observed state of a Git repository."
						properties: {
							artifact: {
								description: "Artifact represents the last successful GitRepository reconciliation."

								properties: {
									digest: {
										description: "Digest is the digest of the file in the form of '<algorithm>:<checksum>'."
										pattern:     "^[a-z0-9]+(?:[.+_-][a-z0-9]+)*:[a-zA-Z0-9=_-]+$"
										type:        "string"
									}
									lastUpdateTime: {
										description: "LastUpdateTime is the timestamp corresponding to the last update of the Artifact."

										format: "date-time"
										type:   "string"
									}
									metadata: {
										additionalProperties: type: "string"
										description: "Metadata holds upstream information such as OCI annotations."
										type:        "object"
									}
									path: {
										description: "Path is the relative file path of the Artifact. It can be used to locate the file in the root of the Artifact storage on the local file system of the controller managing the Source."

										type: "string"
									}
									revision: {
										description: "Revision is a human-readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm chart version, etc."

										type: "string"
									}
									size: {
										description: "Size is the number of bytes in the file."
										format:      "int64"
										type:        "integer"
									}
									url: {
										description: "URL is the HTTP address of the Artifact as exposed by the controller managing the Source. It can be used to retrieve the Artifact for consumption, e.g. by another controller applying the Artifact contents."

										type: "string"
									}
								}
								required: [
									"lastUpdateTime",
									"path",
									"revision",
									"url",
								]
								type: "object"
							}
							conditions: {
								description: "Conditions holds the conditions for the GitRepository."
								items: {
									description: """
			Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
			 type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` 
			 // other fields }
			"""

									properties: {
										lastTransitionTime: {
											description: "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "message is a human readable message indicating details about the transition. This may be an empty string."

											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."

											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."

											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"

											maxLength: 316
											pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:      "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							includedArtifacts: {
								description: "IncludedArtifacts contains a list of the last successfully included Artifacts as instructed by GitRepositorySpec.Include."

								items: {
									description: "Artifact represents the output of a Source reconciliation."
									properties: {
										digest: {
											description: "Digest is the digest of the file in the form of '<algorithm>:<checksum>'."

											pattern: "^[a-z0-9]+(?:[.+_-][a-z0-9]+)*:[a-zA-Z0-9=_-]+$"
											type:    "string"
										}
										lastUpdateTime: {
											description: "LastUpdateTime is the timestamp corresponding to the last update of the Artifact."

											format: "date-time"
											type:   "string"
										}
										metadata: {
											additionalProperties: type: "string"
											description: "Metadata holds upstream information such as OCI annotations."

											type: "object"
										}
										path: {
											description: "Path is the relative file path of the Artifact. It can be used to locate the file in the root of the Artifact storage on the local file system of the controller managing the Source."

											type: "string"
										}
										revision: {
											description: "Revision is a human-readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm chart version, etc."

											type: "string"
										}
										size: {
											description: "Size is the number of bytes in the file."
											format:      "int64"
											type:        "integer"
										}
										url: {
											description: "URL is the HTTP address of the Artifact as exposed by the controller managing the Source. It can be used to retrieve the Artifact for consumption, e.g. by another controller applying the Artifact contents."

											type: "string"
										}
									}
									required: [
										"lastUpdateTime",
										"path",
										"revision",
										"url",
									]
									type: "object"
								}
								type: "array"
							}
							lastHandledReconcileAt: {
								description: "LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change of the annotation value can be detected."

								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last observed generation of the GitRepository object."

								format: "int64"
								type:   "integer"
							}
							observedIgnore: {
								description: "ObservedIgnore is the observed exclusion patterns used for constructing the source artifact."

								type: "string"
							}
							observedInclude: {
								description: "ObservedInclude is the observed list of GitRepository resources used to produce the current Artifact."

								items: {
									description: "GitRepositoryInclude specifies a local reference to a GitRepository which Artifact (sub-)contents must be included, and where they should be placed."

									properties: {
										fromPath: {
											description: "FromPath specifies the path to copy contents from, defaults to the root of the Artifact."

											type: "string"
										}
										repository: {
											description: "GitRepositoryRef specifies the GitRepository which Artifact contents must be included."

											properties: name: {
												description: "Name of the referent."
												type:        "string"
											}
											required: [
												"name",
											]
											type: "object"
										}
										toPath: {
											description: "ToPath specifies the path to copy contents to, defaults to the name of the GitRepositoryRef."

											type: "string"
										}
									}
									required: [
										"repository",
									]
									type: "object"
								}
								type: "array"
							}
							observedRecurseSubmodules: {
								description: "ObservedRecurseSubmodules is the observed resource submodules configuration used to produce the current Artifact."

								type: "boolean"
							}
							sourceVerificationMode: {
								description: "SourceVerificationMode is the last used verification mode indicating which Git object(s) have been verified."

								type: "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}, {
			additionalPrinterColumns: [{
				jsonPath: ".spec.url"
				name:     "URL"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}, {
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}]
			deprecated:         true
			deprecationWarning: "v1beta1 GitRepository is deprecated, upgrade to v1"
			name:               "v1beta1"
			schema: openAPIV3Schema: {
				description: "GitRepository is the Schema for the gitrepositories API"
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "GitRepositorySpec defines the desired state of a Git repository."
						properties: {
							accessFrom: {
								description: "AccessFrom defines an Access Control List for allowing cross-namespace references to this object."

								properties: namespaceSelectors: {
									description: "NamespaceSelectors is the list of namespace selectors to which this ACL applies. Items in this list are evaluated using a logical OR operation."

									items: {
										description: "NamespaceSelector selects the namespaces to which this ACL applies. An empty map of MatchLabels matches all namespaces in a cluster."

										properties: matchLabels: {
											additionalProperties: type: "string"
											description: "MatchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."

											type: "object"
										}
										type: "object"
									}
									type: "array"
								}
								required: [
									"namespaceSelectors",
								]
								type: "object"
							}
							gitImplementation: {
								default:     "go-git"
								description: "Determines which git client library to use. Defaults to go-git, valid values are ('go-git', 'libgit2')."

								enum: [
									"go-git",
									"libgit2",
								]
								type: "string"
							}
							ignore: {
								description: "Ignore overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default will be used, consult the documentation for your version to find out what those are."

								type: "string"
							}
							include: {
								description: "Extra git repositories to map into the repository"
								items: {
									description: "GitRepositoryInclude defines a source with a from and to path."

									properties: {
										fromPath: {
											description: "The path to copy contents from, defaults to the root directory."

											type: "string"
										}
										repository: {
											description: "Reference to a GitRepository to include."
											properties: name: {
												description: "Name of the referent."
												type:        "string"
											}
											required: [
												"name",
											]
											type: "object"
										}
										toPath: {
											description: "The path to copy contents to, defaults to the name of the source ref."

											type: "string"
										}
									}
									required: [
										"repository",
									]
									type: "object"
								}
								type: "array"
							}
							interval: {
								description: "The interval at which to check for repository updates."
								type:        "string"
							}
							recurseSubmodules: {
								description: "When enabled, after the clone is created, initializes all submodules within, using their default settings. This option is available only when using the 'go-git' GitImplementation."

								type: "boolean"
							}
							ref: {
								description: "The Git reference to checkout and monitor for changes, defaults to master branch."

								properties: {
									branch: {
										description: "The Git branch to checkout, defaults to master."
										type:        "string"
									}
									commit: {
										description: "The Git commit SHA to checkout, if specified Tag filters will be ignored."

										type: "string"
									}
									semver: {
										description: "The Git tag semver expression, takes precedence over Tag."

										type: "string"
									}
									tag: {
										description: "The Git tag to checkout, takes precedence over Branch."
										type:        "string"
									}
								}
								type: "object"
							}
							secretRef: {
								description: "The secret name containing the Git credentials. For HTTPS repositories the secret must contain username and password fields. For SSH repositories the secret must contain identity and known_hosts fields."

								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: [
									"name",
								]
								type: "object"
							}
							suspend: {
								description: "This flag tells the controller to suspend the reconciliation of this source."

								type: "boolean"
							}
							timeout: {
								default:     "60s"
								description: "The timeout for remote Git operations like cloning, defaults to 60s."

								type: "string"
							}
							url: {
								description: "The repository URL, can be a HTTP/S or SSH address."
								pattern:     "^(http|https|ssh)://.*$"
								type:        "string"
							}
							verify: {
								description: "Verify OpenPGP signature for the Git commit HEAD points to."

								properties: {
									mode: {
										description: "Mode describes what git object should be verified, currently ('head')."

										enum: [
											"head",
										]
										type: "string"
									}
									secretRef: {
										description: "The secret name containing the public keys of all trusted Git authors."

										properties: name: {
											description: "Name of the referent."
											type:        "string"
										}
										required: [
											"name",
										]
										type: "object"
									}
								}
								required: [
									"mode",
								]
								type: "object"
							}
						}
						required: [
							"interval",
							"url",
						]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "GitRepositoryStatus defines the observed state of a Git repository."
						properties: {
							artifact: {
								description: "Artifact represents the output of the last successful repository sync."

								properties: {
									checksum: {
										description: "Checksum is the SHA256 checksum of the artifact."
										type:        "string"
									}
									lastUpdateTime: {
										description: "LastUpdateTime is the timestamp corresponding to the last update of this artifact."

										format: "date-time"
										type:   "string"
									}
									path: {
										description: "Path is the relative file path of this artifact."
										type:        "string"
									}
									revision: {
										description: "Revision is a human readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm index timestamp, a Helm chart version, etc."

										type: "string"
									}
									url: {
										description: "URL is the HTTP address of this artifact."
										type:        "string"
									}
								}
								required: [
									"path",
									"url",
								]
								type: "object"
							}
							conditions: {
								description: "Conditions holds the conditions for the GitRepository."
								items: {
									description: """
			Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
			 type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` 
			 // other fields }
			"""

									properties: {
										lastTransitionTime: {
											description: "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "message is a human readable message indicating details about the transition. This may be an empty string."

											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."

											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."

											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"

											maxLength: 316
											pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:      "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							includedArtifacts: {
								description: "IncludedArtifacts represents the included artifacts from the last successful repository sync."

								items: {
									description: "Artifact represents the output of a source synchronisation."
									properties: {
										checksum: {
											description: "Checksum is the SHA256 checksum of the artifact."
											type:        "string"
										}
										lastUpdateTime: {
											description: "LastUpdateTime is the timestamp corresponding to the last update of this artifact."

											format: "date-time"
											type:   "string"
										}
										path: {
											description: "Path is the relative file path of this artifact."
											type:        "string"
										}
										revision: {
											description: "Revision is a human readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm index timestamp, a Helm chart version, etc."

											type: "string"
										}
										url: {
											description: "URL is the HTTP address of this artifact."
											type:        "string"
										}
									}
									required: [
										"path",
										"url",
									]
									type: "object"
								}
								type: "array"
							}
							lastHandledReconcileAt: {
								description: "LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change of the annotation value can be detected."

								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last observed generation."
								format:      "int64"
								type:        "integer"
							}
							url: {
								description: "URL is the download link for the artifact output of the last repository sync."

								type: "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: false
			subresources: status: {}
		}, {
			additionalPrinterColumns: [{
				jsonPath: ".spec.url"
				name:     "URL"
				type:     "string"
			}, {
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			deprecated:         true
			deprecationWarning: "v1beta2 GitRepository is deprecated, upgrade to v1"
			name:               "v1beta2"
			schema: openAPIV3Schema: {
				description: "GitRepository is the Schema for the gitrepositories API."
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "GitRepositorySpec specifies the required configuration to produce an Artifact for a Git repository."

						properties: {
							accessFrom: {
								description: "AccessFrom specifies an Access Control List for allowing cross-namespace references to this object. NOTE: Not implemented, provisional as of https://github.com/fluxcd/flux2/pull/2092"

								properties: namespaceSelectors: {
									description: "NamespaceSelectors is the list of namespace selectors to which this ACL applies. Items in this list are evaluated using a logical OR operation."

									items: {
										description: "NamespaceSelector selects the namespaces to which this ACL applies. An empty map of MatchLabels matches all namespaces in a cluster."

										properties: matchLabels: {
											additionalProperties: type: "string"
											description: "MatchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."

											type: "object"
										}
										type: "object"
									}
									type: "array"
								}
								required: [
									"namespaceSelectors",
								]
								type: "object"
							}
							gitImplementation: {
								default:     "go-git"
								description: "GitImplementation specifies which Git client library implementation to use. Defaults to 'go-git', valid values are ('go-git', 'libgit2'). Deprecated: gitImplementation is deprecated now that 'go-git' is the only supported implementation."

								enum: [
									"go-git",
									"libgit2",
								]
								type: "string"
							}
							ignore: {
								description: "Ignore overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default will be used, consult the documentation for your version to find out what those are."

								type: "string"
							}
							include: {
								description: "Include specifies a list of GitRepository resources which Artifacts should be included in the Artifact produced for this GitRepository."

								items: {
									description: "GitRepositoryInclude specifies a local reference to a GitRepository which Artifact (sub-)contents must be included, and where they should be placed."

									properties: {
										fromPath: {
											description: "FromPath specifies the path to copy contents from, defaults to the root of the Artifact."

											type: "string"
										}
										repository: {
											description: "GitRepositoryRef specifies the GitRepository which Artifact contents must be included."

											properties: name: {
												description: "Name of the referent."
												type:        "string"
											}
											required: [
												"name",
											]
											type: "object"
										}
										toPath: {
											description: "ToPath specifies the path to copy contents to, defaults to the name of the GitRepositoryRef."

											type: "string"
										}
									}
									required: [
										"repository",
									]
									type: "object"
								}
								type: "array"
							}
							interval: {
								description: "Interval at which to check the GitRepository for updates."
								pattern:     "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:        "string"
							}
							recurseSubmodules: {
								description: "RecurseSubmodules enables the initialization of all submodules within the GitRepository as cloned from the URL, using their default settings."

								type: "boolean"
							}
							ref: {
								description: "Reference specifies the Git reference to resolve and monitor for changes, defaults to the 'master' branch."

								properties: {
									branch: {
										description: "Branch to check out, defaults to 'master' if no other field is defined."

										type: "string"
									}
									commit: {
										description: """
			Commit SHA to check out, takes precedence over all reference fields. 
			 This can be combined with Branch to shallow clone the branch, in which the commit is expected to exist.
			"""

										type: "string"
									}
									name: {
										description: """
			Name of the reference to check out; takes precedence over Branch, Tag and SemVer. 
			 It must be a valid Git reference: https://git-scm.com/docs/git-check-ref-format#_description Examples: \"refs/heads/main\", \"refs/tags/v0.1.0\", \"refs/pull/420/head\", \"refs/merge-requests/1/head\"
			"""

										type: "string"
									}
									semver: {
										description: "SemVer tag expression to check out, takes precedence over Tag."

										type: "string"
									}
									tag: {
										description: "Tag to check out, takes precedence over Branch."
										type:        "string"
									}
								}
								type: "object"
							}
							secretRef: {
								description: "SecretRef specifies the Secret containing authentication credentials for the GitRepository. For HTTPS repositories the Secret must contain 'username' and 'password' fields for basic auth or 'bearerToken' field for token auth. For SSH repositories the Secret must contain 'identity' and 'known_hosts' fields."

								properties: name: {
									description: "Name of the referent."
									type:        "string"
								}
								required: [
									"name",
								]
								type: "object"
							}
							suspend: {
								description: "Suspend tells the controller to suspend the reconciliation of this GitRepository."

								type: "boolean"
							}
							timeout: {
								default:     "60s"
								description: "Timeout for Git operations like cloning, defaults to 60s."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m))+$"
								type:    "string"
							}
							url: {
								description: "URL specifies the Git repository URL, it can be an HTTP/S or SSH address."

								pattern: "^(http|https|ssh)://.*$"
								type:    "string"
							}
							verify: {
								description: "Verification specifies the configuration to verify the Git commit signature(s)."

								properties: {
									mode: {
										description: "Mode specifies what Git object should be verified, currently ('head')."

										enum: [
											"head",
										]
										type: "string"
									}
									secretRef: {
										description: "SecretRef specifies the Secret containing the public keys of trusted Git authors."

										properties: name: {
											description: "Name of the referent."
											type:        "string"
										}
										required: [
											"name",
										]
										type: "object"
									}
								}
								required: [
									"mode",
									"secretRef",
								]
								type: "object"
							}
						}
						required: [
							"interval",
							"url",
						]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "GitRepositoryStatus records the observed state of a Git repository."
						properties: {
							artifact: {
								description: "Artifact represents the last successful GitRepository reconciliation."

								properties: {
									digest: {
										description: "Digest is the digest of the file in the form of '<algorithm>:<checksum>'."
										pattern:     "^[a-z0-9]+(?:[.+_-][a-z0-9]+)*:[a-zA-Z0-9=_-]+$"
										type:        "string"
									}
									lastUpdateTime: {
										description: "LastUpdateTime is the timestamp corresponding to the last update of the Artifact."

										format: "date-time"
										type:   "string"
									}
									metadata: {
										additionalProperties: type: "string"
										description: "Metadata holds upstream information such as OCI annotations."
										type:        "object"
									}
									path: {
										description: "Path is the relative file path of the Artifact. It can be used to locate the file in the root of the Artifact storage on the local file system of the controller managing the Source."

										type: "string"
									}
									revision: {
										description: "Revision is a human-readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm chart version, etc."

										type: "string"
									}
									size: {
										description: "Size is the number of bytes in the file."
										format:      "int64"
										type:        "integer"
									}
									url: {
										description: "URL is the HTTP address of the Artifact as exposed by the controller managing the Source. It can be used to retrieve the Artifact for consumption, e.g. by another controller applying the Artifact contents."

										type: "string"
									}
								}
								required: [
									"lastUpdateTime",
									"path",
									"revision",
									"url",
								]
								type: "object"
							}
							conditions: {
								description: "Conditions holds the conditions for the GitRepository."
								items: {
									description: """
			Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
			 type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` 
			 // other fields }
			"""

									properties: {
										lastTransitionTime: {
											description: "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "message is a human readable message indicating details about the transition. This may be an empty string."

											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."

											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."

											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"

											maxLength: 316
											pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:      "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							contentConfigChecksum: {
								description: """
			ContentConfigChecksum is a checksum of all the configurations related to the content of the source artifact: - .spec.ignore - .spec.recurseSubmodules - .spec.included and the checksum of the included artifacts observed in .status.observedGeneration version of the object. This can be used to determine if the content of the included repository has changed. It has the format of `<algo>:<checksum>`, for example: `sha256:<checksum>`. 
			 Deprecated: Replaced with explicit fields for observed artifact content config in the status.
			"""

								type: "string"
							}
							includedArtifacts: {
								description: "IncludedArtifacts contains a list of the last successfully included Artifacts as instructed by GitRepositorySpec.Include."

								items: {
									description: "Artifact represents the output of a Source reconciliation."
									properties: {
										digest: {
											description: "Digest is the digest of the file in the form of '<algorithm>:<checksum>'."

											pattern: "^[a-z0-9]+(?:[.+_-][a-z0-9]+)*:[a-zA-Z0-9=_-]+$"
											type:    "string"
										}
										lastUpdateTime: {
											description: "LastUpdateTime is the timestamp corresponding to the last update of the Artifact."

											format: "date-time"
											type:   "string"
										}
										metadata: {
											additionalProperties: type: "string"
											description: "Metadata holds upstream information such as OCI annotations."

											type: "object"
										}
										path: {
											description: "Path is the relative file path of the Artifact. It can be used to locate the file in the root of the Artifact storage on the local file system of the controller managing the Source."

											type: "string"
										}
										revision: {
											description: "Revision is a human-readable identifier traceable in the origin source system. It can be a Git commit SHA, Git tag, a Helm chart version, etc."

											type: "string"
										}
										size: {
											description: "Size is the number of bytes in the file."
											format:      "int64"
											type:        "integer"
										}
										url: {
											description: "URL is the HTTP address of the Artifact as exposed by the controller managing the Source. It can be used to retrieve the Artifact for consumption, e.g. by another controller applying the Artifact contents."

											type: "string"
										}
									}
									required: [
										"lastUpdateTime",
										"path",
										"revision",
										"url",
									]
									type: "object"
								}
								type: "array"
							}
							lastHandledReconcileAt: {
								description: "LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change of the annotation value can be detected."

								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last observed generation of the GitRepository object."

								format: "int64"
								type:   "integer"
							}
							observedIgnore: {
								description: "ObservedIgnore is the observed exclusion patterns used for constructing the source artifact."

								type: "string"
							}
							observedInclude: {
								description: "ObservedInclude is the observed list of GitRepository resources used to to produce the current Artifact."

								items: {
									description: "GitRepositoryInclude specifies a local reference to a GitRepository which Artifact (sub-)contents must be included, and where they should be placed."

									properties: {
										fromPath: {
											description: "FromPath specifies the path to copy contents from, defaults to the root of the Artifact."

											type: "string"
										}
										repository: {
											description: "GitRepositoryRef specifies the GitRepository which Artifact contents must be included."

											properties: name: {
												description: "Name of the referent."
												type:        "string"
											}
											required: [
												"name",
											]
											type: "object"
										}
										toPath: {
											description: "ToPath specifies the path to copy contents to, defaults to the name of the GitRepositoryRef."

											type: "string"
										}
									}
									required: [
										"repository",
									]
									type: "object"
								}
								type: "array"
							}
							observedRecurseSubmodules: {
								description: "ObservedRecurseSubmodules is the observed resource submodules configuration used to produce the current Artifact."

								type: "boolean"
							}
							url: {
								description: "URL is the dynamic fetch link for the latest Artifact. It is provided on a \"best effort\" basis, and using the precise GitRepositoryStatus.Artifact data is recommended."

								type: "string"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: false
			subresources: status: {}
		}]
	}
}