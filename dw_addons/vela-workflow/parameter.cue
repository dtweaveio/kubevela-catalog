package main

const: {
	// +usage=The const name of the resource
	name: "vela-workflow"
	// +usage=The namespace of the addon application
	namespace: "vela-system"
}

parameter: {
	image:                *"registry.cn-hangzhou.aliyuncs.com/dtweave/vela-workflow" | string
	version:              *"0.6.0" | string
	imagePullPolicy:      *"IfNotPresent" | "Never" | "Always"
	concurrentReconciles: *4 | int
	kubeQPS:              *50 | int
	kubeBurst:            *100 | int
	resources: {
		requests: {
			cpu:    *"50m" | string
			memory: *"20Mi" | string
		}
		limits: {
			cpu:    *"500m" | string
			memory: *"1Gi" | string
		}
	}
	maxWorkflowWaitBackoffTime:     *60 | int
	maxWorkflowFailedBackoffTime:   *300 | int
	maxWorkflowStepErrorRetryTimes: *10 | int
}
