// We put Components in resources directory.
// References:
// - https://kubevela.net/docs/end-user/components/references
// - https://kubevela.net/docs/platform-engineers/addon/intro#resources-directoryoptional
package main

kubeblocksCharts: {
	name: "kube-blocks"
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://apecloud.github.io/helm-charts"
		chart:    "kubeblocks"
		version:  "0.9.0"
	}
}