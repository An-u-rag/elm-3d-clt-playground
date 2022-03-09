module CltPlank exposing (cltPlank)

-- Imports as required

-- Function to generate a CLT Plank with variable width, length and height
cltPlank : Float -> Float -> Float -> String -> String -> Model -> Wrapper3D.Object WorldCoordinates
cltPlank width length height topTexture sideTexture model = group3D[
    -- Mesh for top and bottom faces of the plank
    customObject (meshV width length height) False model.meshStore
        |> textured (getColorTexture topTexture model) (constantTexture 0) (constantTexture 0.2)
        |> scale3D 10
    ,
    -- The strip mesh for the sides of the plank
    customObject (rawStripMeshV width length height) False model.meshStore
        |> textured (getColorTexture sideTexture model) (constantTexture 0) (constantTexture 0.2)
        |> scale3D 10 ]



-- Combined mesh with upper + lower rectangular meshes and a Strip mesh for the sides (with variable widths and lengths)
meshV width length height = TriangularMesh.combine [upperMeshV width length height, lowerMeshV width length]

upperMeshV width length height =
    TriangularMesh.indexed
        (Array.fromList [{ position = Point3d.centimeters 0 0 height, uv = (0.0, 0.0)} -- 0
        , { position = Point3d.centimeters length 0 height, uv = (1.0, 0.0)} -- 1
        , { position = Point3d.centimeters length width height, uv = (1.0, 1.0)} -- 2
        , { position = Point3d.centimeters 0 width height, uv = (0.0, 1.0)} -- 3
        , { position = Point3d.centimeters 0 0 height, uv = (0.0, 0.0)}]) 

        ([ (0, 1, 2)
        , (2, 3, 0)
        ])

lowerMeshV width length =
    TriangularMesh.indexed
        (Array.fromList [{ position = Point3d.centimeters 0 0 0, uv = (0.0, 0.0)} -- 0
        , { position = Point3d.centimeters length 0 0, uv = (1.0, 0.0)} -- 1
        , { position = Point3d.centimeters length width 0, uv = (1.0, 1.0)} -- 2
        , { position = Point3d.centimeters 0 width 0, uv = (0.0, 1.0)} -- 3
        , { position = Point3d.centimeters 0 0 0, uv = (0.0, 0.0)}]) 

        ([ (0, 1, 2)
        , (2, 3, 0)
        ])

   
rawStripMeshV width length height =
    TriangularMesh.strip
        [{ position = Point3d.centimeters 0 0 height, uv = (0.0, 0.0)} -- 0
        , { position = Point3d.centimeters length 0 height, uv = (1.0, 0.0)} -- 1
        , { position = Point3d.centimeters length width height, uv = (0.0, 0.0)} -- 2
        , { position = Point3d.centimeters 0 width height, uv = (1.0, 0.0)} -- 3
        , { position = Point3d.centimeters 0 0 height, uv = (0.0, 0.0)}]
        
        [{ position = Point3d.centimeters 0 0 0, uv = (0.0, 1.0)} -- 0
        , { position = Point3d.centimeters length 0 0, uv = (1.0, 1.0)} -- 1
        , { position = Point3d.centimeters length width 0, uv = (0.0, 1.0)} -- 2
        , { position = Point3d.centimeters 0 width 0, uv = (1.0, 1.0)} -- 3
        , { position = Point3d.centimeters 0 0 0, uv = (0.0, 1.0)}] 