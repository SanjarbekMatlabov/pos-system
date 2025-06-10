import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salom_pos/features/3_products/product_model.dart';

// --- STATE'LAR ---

// Savatdagi bitta mahsulotni ifodalaydi
class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});
  
  // Miqdorni o'zgartirish uchun qulay funksiya
  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
  
  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}


// POS ekranining to'liq holati
class PosState extends Equatable {
  final List<CartItem> cartItems;
  final double subtotal; // Oraliq jami (chegirmasiz)
  final double total;    // Yakuniy jami

  const PosState({
    this.cartItems = const [],
    this.subtotal = 0.0,
    this.total = 0.0,
  });

  @override
  List<Object?> get props => [cartItems, subtotal, total];
}

// --- CUBIT ---

class PosCubit extends Cubit<PosState> {
  PosCubit() : super(const PosState());

  void addProduct(Product product) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    final int index = updatedCart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Mahsulot savatda mavjud bo'lsa, sonini oshiramiz
      final item = updatedCart[index];
      updatedCart[index] = item.copyWith(quantity: item.quantity + 1);
    } else {
      // Aks holda, yangi mahsulot qo'shamiz
      updatedCart.add(CartItem(product: product));
    }
    _updateState(updatedCart);
  }

  void incrementQuantity(CartItem cartItem) {
    final List<CartItem> updatedCart = List.from(state.cartItems);
    final int index = updatedCart.indexWhere((item) => item.product.id == cartItem.product.id);
    if (index != -1) {
      final item = updatedCart[index];
      updatedCart[index] = item.copyWith(quantity: item.quantity + 1);
      _updateState(updatedCart);
    }
  }

  void decrementQuantity(CartItem cartItem) {
     final List<CartItem> updatedCart = List.from(state.cartItems);
    final int index = updatedCart.indexWhere((item) => item.product.id == cartItem.product.id);
    if (index != -1) {
      final item = updatedCart[index];
      if (item.quantity > 1) {
        updatedCart[index] = item.copyWith(quantity: item.quantity - 1);
      } else {
        // Miqdor 1 ga teng bo'lsa, o'chirib tashlaymiz
        updatedCart.removeAt(index);
      }
      _updateState(updatedCart);
    }
  }

  void clearCart() {
    _updateState([]);
  }

  // Holatni yangilab, hisob-kitoblarni qayta bajaruvchi yordamchi funksiya
  void _updateState(List<CartItem> cart) {
    double subtotal = 0;
    for (var item in cart) {
      subtotal += item.totalPrice;
    }
    emit(PosState(cartItems: cart, subtotal: subtotal, total: subtotal));
  }
}