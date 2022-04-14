# Chests are bounded containers.

![Wooden chest (domed lid) with fittings, 17th c.](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Coffe_en_bois_du_beffroi_de_Bruges.jpg/1599px-Coffe_en_bois_du_beffroi_de_Bruges.jpg?20110916140257)

Many embedded systems do not support dynamic memory allocation, but sometimes you need to process variable-sized things. [Chests.Stacks](src/chests-stacks.ads) and [Chests.Ring_Buffers](src/chests-ring_buffers.ads) are generic packages that have a fixed Capacity and only use statically allocated memory.

The Ada standard library includes some bounded containers. Annex A recommends, but does not require, that implementations of those containers avoid dynamic allocation. Further, these packages depend on other units that are not available with minimal runtimes (aka. ZFP, Light, nostd). Chests have no external dependencies and should work with any Ada runtime.
