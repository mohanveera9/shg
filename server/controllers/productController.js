const Product = require('../models/Product');

const createProduct = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { title, description, price, stock, photoUrl } = req.body;
    const userId = req.user._id;
    
    if (!title || !price || price < 0 || !stock || stock < 0 || !photoUrl) {
      return res.status(400).json({ success: false, message: 'Title, price, stock, and photo are required' });
    }
    
    const product = await Product.create({
      groupId,
      title,
      description: description || '',
      price,
      stock,
      photoUrl,
      createdBy: userId
    });
    
    res.status(201).json({
      success: true,
      message: 'Product created successfully',
      product
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error creating product', error: error.message });
  }
};

const getProducts = async (req, res) => {
  try {
    const { groupId } = req.params;
    
    const products = await Product.find({ groupId, isActive: true })
      .populate('createdBy', 'name phone')
      .sort({ createdAt: -1 });
    
    res.status(200).json({
      success: true,
      products
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching products', error: error.message });
  }
};

const getProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    
    const product = await Product.findById(productId)
      .populate('createdBy', 'name phone')
      .populate('groupId', 'name');
    
    if (!product) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    
    res.status(200).json({
      success: true,
      product
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching product', error: error.message });
  }
};

const updateProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const { title, description, price, stock, photoUrl } = req.body;
    
    const product = await Product.findById(productId);
    
    if (!product) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    
    if (title) product.title = title;
    if (description !== undefined) product.description = description;
    if (price !== undefined) product.price = price;
    if (stock !== undefined) product.stock = stock;
    if (photoUrl) product.photoUrl = photoUrl;
    
    await product.save();
    
    res.status(200).json({
      success: true,
      message: 'Product updated successfully',
      product
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error updating product', error: error.message });
  }
};

module.exports = {
  createProduct,
  getProducts,
  getProduct,
  updateProduct
};
