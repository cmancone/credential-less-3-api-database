from collections import OrderedDict
from clearskies import Model
from clearskies import column_types
from clearskies.input_requirements import required, maximum_length
from . import manufacturer, category, product_category


class Product(Model):
    def __init__(self, cursor_backend, columns):
        super().__init__(cursor_backend, columns)

    def columns_configuration(self):
        return OrderedDict([
            column_types.belongs_to('manufacturer_id', parent_models_class=manufacturer.Manufacturer),
            column_types.string('name', input_requirements=[required(), maximum_length(255)]),
            column_types.string('short_description', input_requirements=[maximum_length(255)]),
            column_types.string('description', input_requirements=[required(), maximum_length(1024)]),
            column_types.string('manufacturer_part_number', input_requirements=[required(), maximum_length(255)]),
            column_types.float('cost'),
            column_types.float('price'),
            column_types.updated('updated_at'),
            column_types.created('created_at'),
            column_types.many_to_many('categories', pivot_models_class=product_category.ProductCategory, related_models_class=category.Category, is_readable=True, readable_related_columns=['name']),
        ])
