output: {
	name: "vm-cluster"
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.dtweave.com/kubevela/"
		chart:    "victoria-metrics-cluster"
		version:  "0.10.9"
		targetNamespace: parameter.namespace
		values: {
			vminsert: {
				fullnameOverride: "victoria-metrics-cluster-vminsert"
			}
			vmselect: {
				fullnameOverride: "victoria-metrics-cluster-vmselect"
			}
			vmstorage: {
				fullnameOverride: "victoria-metrics-cluster-vmstorage"
			}
		}
	}
	
}