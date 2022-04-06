from collections import OrderedDict
from clearskies import Model
from clearskies import column_types
from . import category, product


class ProductCategory(Model):
    def __init__(self, cursor_backend, columns):
        super().__init__(cursor_backend, columns)

    def columns_configuration(self):
        return OrderedDict([
            column_types.belongs_to('product_id', parent_models_class=product.Product),
            column_types.belongs_to('category_id', parent_models_class=category.Category),
        ])
