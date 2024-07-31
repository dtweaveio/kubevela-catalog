package main

kubeblocksCharts: {
	name: "kubeblocks"
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://apecloud.github.io/helm-charts"
		chart:    "kubeblocks"
		version:  "0.9.0"
	}
}