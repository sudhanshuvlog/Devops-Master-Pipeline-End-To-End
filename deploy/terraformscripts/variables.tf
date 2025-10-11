variable "instanceType" {
    type    = string
    default = "t3.medium"
}

variable "instance_count" {
    type    = number
    default = 2
}

variable "x" {
    type    = string
    default = "hello"
}

variable "instanceTagName" {
    type    = string
    default = "gfg-terraform"
}

variable "sg_name" {
    type    = string
    default = "webserver-sg"
}

variable "key_name" {
    type    = string
    default = "gfg37ansible"
}

variable "public_key_path" {
    type    = string
    default = "./mykey.pub"
}

variable "allowedPort" {
    type = list(number)
    default = [
        6443,  # Kubernetes API server
        2379,  # etcd server client API
        2380,  # etcd server peer API
        10250, # Kubelet API
        10251, # kube-scheduler
        10252, # kube-controller-manager
        30000, # NodePort Services start
        32767, # NodePort Services end
        80,
        22,
        8080,
        3000,
        9090,
        4789,
        179,
        4,
        5473,
        10250,
        443,
        80,
        53
    ]
}
