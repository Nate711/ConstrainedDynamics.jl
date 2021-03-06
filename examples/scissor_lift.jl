using ConstrainedDynamics


# Parameters
ex = [1.;0.;0.]
ey = [0.;1.;0.]
ez = [0.;0.;1.]

l1 = 1.0
x, y = .1, .1
b1 = Box(x, y, l1, l1, color = RGBA(1., 1., 0.))

vert11 = [0.;0.;l1 / 2]
vert12 = -vert11

# Initial orientation
phi1, phi2, phi3 = pi / 4, -pi / 4, pi / 2
q1, q2, q3 = Quaternion(RotX(phi1)), Quaternion(RotX(phi2)), Quaternion(RotX(phi3))

# Links
origin = Origin{Float64}()
link1 = Body(b1)
link2 = Body(b1)

# Constraints
joint0to12 = EqualityConstraint(CylindricalFree(origin, link1, zeros(3), vert11, ey), Spherical(origin, link2, zeros(3), vert11))
joint1to2 = EqualityConstraint(CylindricalFree(link1, link2, zeros(3), zeros(3), ex))


links = [link1; link2]
constraints = [joint0to12;joint1to2]
shapes = [b1]

mech = Mechanism(origin, links, constraints, shapes = shapes)
setPosition!(mech,origin,link1,p1 = [0;-0.5 * sqrt(2);0],p2 = vert11,Δq = q1)
setPosition!(mech,origin,link2,p2 = vert11,Δq = q2)

simulate!(mech,save = true)
visualize!(mech)
