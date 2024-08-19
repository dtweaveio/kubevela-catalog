package main

import "encoding/json"

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

outputs: resourceRelation: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "kubeblocks-relation"
		namespace: "vela-system"
		labels: {
			"rules.oam.dev/resources":       "true"
			"rules.oam.dev/resource-format": "json"
		}
	}
	data: {
		rules: json.Marshal(_rules)
	}
}

_rules: [
	{
		parentResourceType: {
			group: "apps.kubeblocks.io"
			kind:  "Cluster"
		}
		childrenResourceType: [
			{
				apiVersion: "apps.kubeblocks.io/v1alpha1"
				kind:       "Component"
			},
		]
	},
	{
		parentResourceType: {
			group: "apps.kubeblocks.io"
			kind:  "Component"
		}
		childrenResourceType: [
			{
				apiVersion: "workloads.kubeblocks.io/v1alpha1"
				kind:       "InstanceSet"
			},
		]
	},
	{
		parentResourceType: {
			group: "workloads.kubeblocks.io"
			kind:  "InstanceSet"
		}
		childrenResourceType: [
			{
				apiVersion: "v1"
				kind:       "Pod"
			},
		]
	},
]