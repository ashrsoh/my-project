import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          'title': 'إدارة المنتجات',
          'delete_confirm': 'هل أنت متأكد من أنك تريد حذف هذا المنتج؟',
          'delete': 'حذف',
          'cancel': 'إلغاء',
          'price': 'السعر',
          'stock': 'المخزون',
          'edit': 'تعديل',
          'add_product': 'إضافة منتج',
        },
        'en': {
          'title': 'Product Management',
          'delete_confirm': 'Are you sure you want to delete this product?',
          'delete': 'Delete',
          'cancel': 'Cancel',
          'price': 'Price',
          'stock': 'Stock',
          'edit': 'Edit',
          'add_product': 'Add Product',
        },
      };
}
