package main

_targetNamespace: *"kb-system" | string
if parameter.namespace != _|_ {
	_targetNamespace: parameter.namespace
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [kubeblocksCharts]
		policies: [
			{
				type: "topology"
				name: "deploy-kubeblocks"
					properties: {
					namespace: _targetNamespace
					if parameter.clusters != _|_ {
						clusters: parameter.clusters
					}
					if parameter.clusters == _|_ {
						clusterLabelSelector: {}
					}
				}
			}
		]
	}
}
