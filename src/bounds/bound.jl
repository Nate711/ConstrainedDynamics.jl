abstract type Bound{T} end

Base.show(io::IO, bound::Bound) = summary(io, bound)

@inline getT(bound::Bound{T}) where T = T


@inline g(bound::Bound{T}) where T = zero(T)

@inline ∂g∂pos(bound::Bound{T}) where T = @SVector zeros(T, 6)
@inline ∂g∂vel(bound::Bound{T}) where T = @SVector zeros(T, 6)
@inline schurf(bound::Bound{T}) where T = @SVector zeros(T, 6)
@inline schurD(bound::Bound{T}) where T = @SMatrix zeros(T, 6, 6)

