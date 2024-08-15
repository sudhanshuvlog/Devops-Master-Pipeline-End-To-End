variable "instanceType"{
type = string
default = "t2.medium"
}

variable "x"{
    type = string
    default = "hello"
}

variable "instanceTagName"{
    type = string
    default = "GFGTerraform"
}

variable "amiID"{
    default ="ami-0a0f1259dd1c90938"
}

variable "sg_name"{
    default = "WebserverSg"
}
