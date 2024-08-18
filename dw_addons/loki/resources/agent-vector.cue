package main

vector: {
	name: "vector"
	type: "daemon"
	dependsOn: [o11yNamespace.name, vectorConfig.name]
	properties: {
		image:           parameter.vectorImage
		imagePullPolicy: parameter.imagePullPolicy
		if parameter.agent == "vector" && parameter.stdout == "" {
			labels: "vector.oam.dev/agent": "true"
		}
		env: [{
			name: "VECTOR_SELF_NODE_NAME"
			valueFrom: fieldRef: fieldPath: "spec.nodeName"
		}, {
			name: "VECTOR_SELF_POD_NAME"
			valueFrom: fieldRef: fieldPath: "metadata.name"
		}, {
			name: "VECTOR_SELF_POD_NAMESPACE"
			valueFrom: fieldRef: fieldPath: "metadata.namespace"
		}, {
			name:  "PROCFS_ROOT"
			value: "/host/proc"
		}, {
			name:  "SYSFS_ROOT"
			value: "/host/sys"
		}]
		volumeMounts: {
			configMap: [
				{
					name:      "bootconfig-volume"
					mountPath: "/etc/bootconfig"
					cmName:    "vector"
				},
				if parameter.agent == "vector" && parameter.stdout == "" {
					name:      "vector-controller-config"
					mountPath: "/etc/vector-controller-config"
					cmName:    "vector-controller"
				},
			]
			hostPath: [{
				name:      "data"
				path:      "/var/lib/vector"
				mountPath: "/vector-data-dir"
			}, {
				name:      "var-log"
				path:      "/var/log/"
				mountPath: "/var/log/"
				readOnly:  true
			}, {
				name:      "var-lib"
				path:      "/var/lib/"
				mountPath: "/var/lib/"
				readOnly:  true
			}, {
				name:      "procfs"
				path:      "/proc"
				mountPath: "/host/proc"
				readOnly:  true
			}, {
				name:      "sysfs"
				path:      "/sys"
				mountPath: "/host/sys"
				readOnly:  true
			}]
		}
	}
	traits: [{
		type:       "command"
		_configDir: *"/etc/config/" | string
		if parameter.agent == "vector" && parameter.stdout == "" {
			_configDir: "/etc/config/,/etc/vector-controller-config/"
		}
		properties: args: [
			"--config-dir",
			_configDir,
			"-w",
		]
	}, {
		agentServiceAccount
		properties: name: "vector"
	}, agentInitContainer]
}

vectorConfig: {
	name: "vector-config"
	type: "k8s-objects"
	dependsOn: [o11yNamespace.name]
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "vector"
		if parameter.agent == "vector" && parameter.stdout == "all" {
			data: {
				"agent.yaml": #"""
					data_dir: /vector-data-dir
					sources:
					  kubernetes-logs:
					    type: kubernetes_logs
					sinks:
					  loki:
					    type: loki
					    inputs:
					      - kubernetes-logs
					"""# +
					"\n    endpoint: " + lokiURL + "\n" +
					#"""
						    compression: none
						    request:
						      concurrency: 10
						    labels:
						      agent: vector
						      cluster: $CLUSTER
						      stream: "{{ stream }}"
						      forward: daemon
						      filename: "{{ file }}"
						      pod: "{{ kubernetes.pod_name }}"
						      namespace: "{{ kubernetes.pod_namespace }}"
						      container: "{{ kubernetes.container_name }}"
						    encoding:
						      codec: json
						"""#
			}
		}
		if parameter.agent == "vector" && parameter.stdout == "" {
			data: {
				"agent.yaml": #"""
					data_dir: /vector-data-dir
					sources:
					  kubernetes-logs:
					    type: kubernetes_logs
					    extra_label_selector: "kube-event-logger=true"
					sinks:
					  loki:
					    type: loki
					    inputs:
					      - kubernetes-logs
					"""# +
					"\n    endpoint: " + lokiURL + "\n" +
					#"""
						    compression: none
						    request:
						      concurrency: 10
						    labels:
						      agent: vector
						      cluster: $CLUSTER
						      stream: "{{ stream }}"
						      forward: daemon
						      filename: "{{ file }}"
						      pod: "{{ kubernetes.pod_name }}"
						      namespace: "{{ kubernetes.pod_namespace }}"
						      container: "{{ kubernetes.container_name }}"
						    encoding:
						      codec: json
						"""#
			}
		}
	}]
}
