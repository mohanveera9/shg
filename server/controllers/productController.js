const Product = require('../models/Product');
const Group = require('../models/Group');

const getProducts = async (req, res) => {
  try {
    const { groupId } = req.params;
    const userId = req.userId;

    // Verify user is a member of the group
    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    const products = await Product.find({ groupId })
      .populate('createdBy', 'name phone')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      products: products.map(product => ({
        id: product._id,
        title: product.title,
        description: product.description,
        price: product.price,
        stock: product.stock,
        photoUrl: product.photoUrl,
        category: product.category,
        createdBy: product.createdBy,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      })),
    });
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching products',
      error: error.message,
    });
  }
};

const createProduct = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { title, description, price, stock, photoUrl, category } = req.body;
    const userId = req.userId;

    if (!title || !price || stock === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Title, price, and stock are required',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    const product = new Product({
      groupId,
      title,
      description: description || '',
      price: parseFloat(price),
      stock: parseInt(stock),
      photoUrl: photoUrl || null,
      category: category || '',
      createdBy: userId,
    });

    await product.save();
    await product.populate('createdBy', 'name phone');

    res.status(201).json({
      success: true,
      message: 'Product created successfully',
      product: {
        id: product._id,
        title: product.title,
        description: product.description,
        price: product.price,
        stock: product.stock,
        photoUrl: product.photoUrl,
        category: product.category,
        createdBy: product.createdBy,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error creating product:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating product',
      error: error.message,
    });
  }
};

const getProductDetail = async (req, res) => {
  try {
    const { productId } = req.params;
    const userId = req.userId;

    const product = await Product.findById(productId).populate('createdBy', 'name phone');
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(product.groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    res.json({
      success: true,
      product: {
        id: product._id,
        title: product.title,
        description: product.description,
        price: product.price,
        stock: product.stock,
        photoUrl: product.photoUrl,
        category: product.category,
        createdByName: product.createdBy?.name || 'Unknown',
        createdBy: product.createdBy,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error fetching product detail:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching product detail',
      error: error.message,
    });
  }
};

const updateProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const { title, description, price, stock, photoUrl, category } = req.body;
    const userId = req.userId;

    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    // Verify user is a member of the group
    const group = await Group.findById(product.groupId);
    if (!group) {
      return res.status(404).json({
        success: false,
        message: 'Group not found',
      });
    }

    const isMember = group.members.some(m => m.userId.toString() === userId);
    if (!isMember) {
      return res.status(403).json({
        success: false,
        message: 'You are not a member of this group',
      });
    }

    // Update product fields
    if (title !== undefined) product.title = title;
    if (description !== undefined) product.description = description;
    if (price !== undefined) product.price = parseFloat(price);
    if (stock !== undefined) product.stock = parseInt(stock);
    if (photoUrl !== undefined) product.photoUrl = photoUrl;
    if (category !== undefined) product.category = category;
    product.updatedAt = new Date();

    await product.save();
    await product.populate('createdBy', 'name phone');

    res.json({
      success: true,
      message: 'Product updated successfully',
      product: {
        id: product._id,
        title: product.title,
        description: product.description,
        price: product.price,
        stock: product.stock,
        photoUrl: product.photoUrl,
        category: product.category,
        createdBy: product.createdBy,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      },
    });
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating product',
      error: error.message,
    });
  }
};

module.exports = {
  getProducts,
  getProductDetail,
  createProduct,
  updateProduct,
};

