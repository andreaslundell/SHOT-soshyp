module MyFuncs

export add_two_numbers

function add_two_numbers(x::Int, y::Int)
    return x + y
end

function sos_hyp(x::Int, y::Int)
    v = [[[1], [2], [3], [4], [5], [6], [7], [8], []],
    [[1], [2], [3], [4], [5], [6], [7], [8], []],[[1],
    [2], [3], [4], [5], [6], [7], [8], []]]
    c = [[9.126767581240286e-5, 9.999999920148998e-5, 9.9999999993889e-5, 0.000989133593321651, 0.0009999999994120513, 0.0008633872474196243, 0.0009999999994840304, 0.000999999999714911, -1.5497840087417278],
    [9.977360794109321e-5, 9.527519121129219e-5, 9.999999999904306e-5, -0.000999999999969793, 0.0009999999998144494, 0.0009977905969206107, -0.0009999999999743166, 0.0009999999998118294, -0.9368302843483285],
    [9.999999896640233e-5, 9.999999996409077e-5, 9.999999997838982e-5, -0.0008157249856887175, -0.00099999999659609, -0.0008191011377436286, 0.0009999999928611196, -0.0009999999969236028, 0.0958421453439589]]
    return v,c
end

end