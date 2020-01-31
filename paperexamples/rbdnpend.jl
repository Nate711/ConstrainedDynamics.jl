using LinearAlgebra
using RigidBodyDynamics
using StaticArrays
using BenchmarkTools
using Rotations
using LinearAlgebra

using MeshCatMechanisms

g = -9.81

l1 = 1.
m1 = l1
I1 = diagm([0.0845833;0.0845833;0.00125])

# axis = SVector(1., 0., 0.)

function test(state,jointies,N)
    q =  [0.9238795325112867; 0.3826834323650897; 0.0; 0.0]
    set_configuration!(state, jointies[1], q)
    q =  [1.; 0.0; 0.0; 0.0]
    for i = 2:N
        @eval begin
            set_configuration!($state, $jointies[$i], $q)
        end
    end
    setdirty!(state)
    simulate(state, 10., Δt = 0.01)
end

val2 = zeros(100)

# for N=[[i for i=1:9];[i for i=10:10:70]]
for N = 100
    world = RigidBody{Float64}("world")
    npend = Mechanism(world; gravity = SVector(0., 0., g))

    joint1 = Joint("joint1", QuaternionSpherical{Float64}())
    inertia1 = SpatialInertia(frame_after(joint1),com=SVector(0, 0, -l1/2),moment_about_com=I1,mass=m1)
    link1 = RigidBody(inertia1)
    before_joint1_to_world = one(Transform3D,frame_before(joint1), default_frame(world))
    attach!(npend, world, link1, joint1,joint_pose = before_joint1_to_world)

    jointies = [joint1]
    links = [link1]

    for i = 2:N
        @eval begin
            $(Symbol("joint",i)) = Joint("joint"*string($i), QuaternionSpherical{Float64}())
            $(Symbol("inertia",i)) = SpatialInertia(frame_after($(Symbol("joint",i))),com=SVector(0, 0, -l1/2),moment_about_com=I1,mass=m1)
            $(Symbol("link",i)) = RigidBody($(Symbol("inertia",i)))
            $(Symbol("before_joint",i,"_to_after_joint",i-1)) = Transform3D(frame_before($(Symbol("joint",i))), frame_after($jointies[$i-1]), SVector(0, 0., -l1))
            attach!($npend, $links[$i-1], $(Symbol("link",i)), $(Symbol("joint",i)),joint_pose = $(Symbol("before_joint",i,"_to_after_joint",i-1)))

            push!($links,$(Symbol("link",i)))
            push!($jointies, $(Symbol("joint",i)))
        end
    end

    state = MechanismState(npend)
    result = DynamicsResult(npend);

    t = @benchmarkable test($state,$jointies,$N)
    val2[N] = BenchmarkTools.minimum(run(t,samples=100,seconds=100)).time
end
