kbcluster: {
	alias: "cluster"
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "apps.kubeblocks.io/v1alpha1"
		kind:       "Cluster"
	}
	description: ""
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "apps.kubeblocks.io/v1alpha1"
		kind:       "Cluster"
		metadata: {
			name:      context.name
			namespace: context.namespace
			if parameter.labels != _|_ {
				labels: parameter.labels
			}
			if parameter.annotations != _|_ {
				annotations: parameter.annotations
			}
		}
		spec: {
			if parameter["terminationPolicy"] != _|_ {
				terminationPolicy: parameter.terminationPolicy
			}
			if parameter["clusterDefinitionRef"] != _|_ {
				clusterDefinitionRef: parameter.clusterDefinitionRef
			}
			if parameter["clusterVersionRef"] != _|_ {
				clusterVersionRef: parameter.clusterVersionRef
			}
			if parameter.topology != _|_ {
				topology: parameter.topology
			}
			if parameter["affinity"] != _|_ {
				affinity: parameter.affinity
			}
			if parameter["tolerations"] != _|_ {
				tolerations: parameter.tolerations
			}
			if parameter["schedulingPolicy"] != _|_ {
				schedulingPolicy: parameter.schedulingPolicy
			}
			if parameter["runtimeClassName"] != _|_ {
				runtimeClassName: parameter.runtimeClassName
			}
			if parameter["backup"] != _|_ {
				backup: {
					if parameter.backup.enabled != _|_ {
						enabled: parameter.backup.enabled
					}
					if parameter.backup.retentionPeriod != _|_ {
						retentionPeriod: parameter.backup.retentionPeriod
					}
					if parameter.backup.method != _|_ {
						method: parameter.backup.method
					}
					if parameter.backup.cronExpression != _|_ {
						cronExpression: parameter.backup.cronExpression
					}
					if parameter.backup.startingDeadlineMinutes != _|_ {
						startingDeadlineMinutes: parameter.backup.startingDeadlineMinutes
					}
					if parameter.backup.repoName != _|_ {
						repoName: parameter.backup.repoName
					}
					if parameter.backup.pitrEnabled != _|_ {
						pitrEnabled: parameter.backup.pitrEnabled
					}
				}
			}
			if parameter["	componentSpecs"] != _|_ {
				componentSpecs: [for v in parameter.componentSpecs {
					name: v.name
					if v.componentDef != _|_ {
						componentDef: v.componentDef
					}
					if v.componentDefRef != _|_ {
						componentDefRef: v.componentDefRef
					}
					if v.serviceVersion != _|_ {
						serviceVersion: v.serviceVersion
					}
					if v.enabledLogs != _|_ {
						enabledLogs: v.enabledLogs
					}
					if v.labels != _|_ {
						labels: v.labels
					}
					if v.annotations != _|_ {
						annotations: v.annotations
					}
					if v.env != _|_ {
						env: v.env
					}
					if v.replicas != _|_ {
						replicas: v.replicas
					}
					if v.affinity != _|_ {
						affinity: v.affinity
					}
					if v.tolerations != _|_ {
						tolerations: v.tolerations
					}
					if v.schedulingPolicy != _|_ {
						schedulingPolicy: v.schedulingPolicy
					}
					if v.resources != _|_ {
						resources: v.resources
					}
					if v.volumeClaimTemplates != _|_ {
						volumeClaimTemplates: v.volumeClaimTemplates
					}
					if v.volumes != _|_ {
						volumes: v.volumes
					}
					if v.services != _|_ {
						services: v.services
					}
					if v.serviceAccountName != _|_ {
						serviceAccountName: v.serviceAccountName
					}
					if v.updateStrategy != _|_ {
						updateStrategy: v.updateStrategy
					}
					if v.stop != _|_ {
						stop: v.stop
					}
				}]
			}
		}
	}

	outputs: {}

	parameter: {
		//
		labels?: [string]: string
		//
		annotations?: [string]: string
		//+usage=Specifies the name of the ClusterDefinition to use when creating a Cluster.
		clusterDefinitionRef?: string
		// @deprecated since 0.9.0
		// Refers to the ClusterVersion name.
		clusterVersionRef?: string
		//+usage=Specifies the name of the ClusterTopology to be used when creating the Cluster.
		topology?: string
		//+usage=Specifies the behavior when a Cluster is deleted.
		terminationPolicy: *"Delete" | "Halt" | "DoNotTerminate" | "WipeOut"
		//+usage=Specifies a list of ClusterComponentSpec objects used to define the individual Components that make up a Cluster.
		componentSpec: [...#ComponentSpec]
		//+usage=Defines a set of node affinity scheduling rules for the Cluster's Pods.
		affinity?: {...}
		//+usage=An array that specifies tolerations attached to the Cluster's Pods,
		tolerations?: [...]
		//+usage=Specifies the scheduling policy for the Cluster.
		schedulingPolicy?: {...}
		//+usage=Specifies runtimeClassName for all Pods managed by this Cluster.
		runtimeClassName?: string
		//+usage=Specifies the backup configuration of the Cluster.
		backup?: #ClusterBackup
		//services: [...#ClusterService]
	}

	#ComponentSpec: {
		//+usage=Specifies the Component's name.
		name: string
		//+usage=References the name of a ComponentDefinition object.
		componentDef: string
		// @deprecated since 0.9.0
		componentDefRef?: string
		//+usage=ServiceVersion specifies the version of the Service expected to be provisioned by this Component.
		serviceVersion: string
		//+usage=Specifies which types of logs should be collected for the Component.
		enabledLogs: [...string]
		//+usage=Specifies Labels to override or add for underlying Pods.
		labels?: [string]: string
		//+usage=Specifies Annotations to override or add for underlying Pods.
		annotations?: [string]: string
		//+usage=List of environment variables to add.
		env?: [...{
			// +usage=Environment variable name
			name: string
			// +usage=The value of the environment variable
			value?: string
			// +usage=Specifies a source the value of this var should come from
			valueFrom?: {
				// +usage=Selects a key of a secret in the pod's namespace
				secretKeyRef?: {
					// +usage=The name of the secret in the pod's namespace to select from
					name: string
					// +usage=The key of the secret to select from. Must be a valid secret key
					key: string
				}
				// +usage=Selects a key of a config map in the pod's namespace
				configMapKeyRef?: {
					// +usage=The name of the config map in the pod's namespace to select from
					name: string
					// +usage=The key of the config map to select from. Must be a valid secret key
					key: string
				}
			}
		}]
		//+usage=Specifies the desired number of replicas in the Component for enhancing availability and durability, or load balancing.
		replicas: *1 | int
		//+usage=Specifies a group of affinity scheduling rules for the Component.
		affinity: *{} | {...}
		//+usage=Allows Pods to be scheduled onto nodes with matching taints.
		tolerations: *[] | [...]
		//+usage=Specifies the scheduling policy for the Component.
		schedulingPolicy: *{} | {...}
		//+usage=Specifies the resources required by the Component.
		resources: *{} | {...}
		//+usage=Specifies a list of PersistentVolumeClaim templates that represent the storage requirements for the Component.
		volumeClaimTemplates: *[] | [...]
		//+usage=List of volumes to override.
		volumes: *[] | [...]
		//+usage=Overrides services defined in referenced ComponentDefinition and expose endpoints that can be accessed by clients.
		services: *[] | [...]
		//+usage=Specifies the name of the ServiceAccount required by the running Component.
		serviceAccountName: *"" | string
		//+usage=Defines the update strategy for the Component.
		updateStrategy: *{} | {...}
		//+usage=Stop the Component.
		stop: *false | bool
		// Overrides system accounts defined in referenced ComponentDefinition.
		//systemAccounts: *{} | {...}
		// configs
		// switchPolicy
		// tls
		// issuer
		// parallelPodManagementConcurrency
		// podUpdatePolicy
		// userResourceRefs
		// instances
		// offlineInstances
		// disableExporter
		// serviceRefs
	}

	#ClusterBackup: {
		// Specifies whether automated backup is enabled for the Cluster.
		enabled: *false | bool
		// Determines the duration to retain backups. Backups older than this period are automatically removed.
		retentionPeriod: *{} | {...}
		// Specifies the backup method to use, as defined in backupPolicy.
		method: *"" | string
		// The cron expression for the schedule. The timezone is in UTC. See https://en.wikipedia.org/wiki/Cron.
		cronExpression: *"" | string
		// Specifies the maximum time in minutes that the system will wait to start a missed backup job.
		startingDeadlineMinutes?: int
		// Specifies the name of the backupRepo. If not set, the default backupRepo will be used.
		repoName: *"" | string
		//  Specifies whether to enable point-in-time recovery.
		pitrEnabled: *false | bool
	}
}
