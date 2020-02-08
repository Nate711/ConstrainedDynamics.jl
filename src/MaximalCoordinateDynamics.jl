module MaximalCoordinateDynamics

# using TimerOutputs
# const to = TimerOutput()

using LinearAlgebra, StaticArrays
using StaticArrays: SUnitRange
using Rotations

using CoordinateTransformations
using GeometryTypes:
    GeometryPrimitive, GeometryTypes, Vec, Point, Rectangle,
    HomogenousMesh, SignedDistanceField, HyperSphere, GLUVMesh, Pyramid
using Blink
using Colors: RGBA, RGB
using FileIO, MeshIO
using MeshCat

using Plots

export
    Box,
    Cylinder,

    Quaternion,
    Origin,
    Body,
    Constraint,
    Mechanism,

    OriginConnection,
    Axis,
    Spherical,
    Cylindrical,
    Revolute,
    Planar,

    setInit!,
    simulate!,
    plotθ,
    plotλ,
    visualize,

    simulate_energy!,
    simulate_drift!,
    simulate_reset!,
    simulate_steptol!


include(joinpath("util", "util.jl"))
include(joinpath("util", "customdict.jl"))
include(joinpath("util", "quaternion.jl"))
include(joinpath("util", "shapes.jl"))
include(joinpath("components", "component.jl"))
include(joinpath("joints", "joint.jl"))
include(joinpath("components", "body.jl"))
include(joinpath("components", "constraint.jl"))

include(joinpath("joints", "originconnection.jl"))
include(joinpath("joints", "axis.jl"))
include(joinpath("joints", "translational0.jl"))
include(joinpath("joints", "translational1.jl"))
include(joinpath("joints", "translational2.jl"))
include(joinpath("joints", "prototypes.jl"))

include(joinpath("util", "graph.jl"))
include(joinpath("util", "storage.jl"))

include(joinpath("solver", "sparseldu.jl"))
include(joinpath("components", "mechanism.jl"))
include(joinpath("solver", "solverfunctions.jl"))

include(joinpath("solver", "newton.jl"))

include(joinpath("util", "visualize.jl"))

end
