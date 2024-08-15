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

variable "sg_name"{
    default = "WebserverSg"
}
