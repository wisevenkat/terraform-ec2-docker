from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams.aws.general import User

with Diagram("web", show=False, direction="TB"):
    User("internet user") >> ELB("alb") >> [EC2("web1"),
                  EC2("web2"),
                  ]