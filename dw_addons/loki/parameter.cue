package main

const: {
	// +usage=The name of the addon application
	name: "addon-loki"
}

parameter: {

	// global parameters

	// +usage=The namespace of the loki to be installed
	namespace: *"o11y-system" | string
	// +usage=The clusters to install
	clusters?: [...string]

	// loki parameters

	// +usage=Specify the image of loki
	image: *"registry.cn-hangzhou.aliyuncs.com/dtweave/loki:2.6.1" | string
	// +usage=Specify the imagePullPolicy of the image
	imagePullPolicy: *"IfNotPresent" | "Never" | "Always"
	// +usage=Specify the service type for expose loki. If empty, it will be not exposed.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer" | ""
	// +usage=Specify the storage size to use. If empty, emptyDir will be used. Otherwise pvc will be used.
	storage?: =~"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"
	// +usage=Specify the storage class to use.
	storageClassName?: string

	// agent parameters

	// +usage=Specify the type of log agents, if empty, no agent will be installed
	agent: *"vector" | "" | "promtail"
	// +usage=Specify the image of promtail
	promtailImage: *"grafana/promtail" | string
	// +usage=Specify the image of vector
	vectorImage:           *"registry.cn-hangzhou.aliyuncs.com/dtweave/vector:0.25.2-distroless-libc" | string
	vectorControllerImage: *"registry.cn-hangzhou.aliyuncs.com/dtweave/vector-controller:0.2.2" | string
	// +usage=collect all pods' stdout log
	stdout: *"" | "all"
	// +usage=The loki URL for vector agent to sink. If not specified, the in cluster loki endpoint will be used.
	lokiURL?: string
	// +usage=If set to true, only agent will be installed.
	agentOnly: *false | bool
}
