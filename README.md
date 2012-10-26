SpreeCsvImports
===============

Install notes to follow....


Available Imports
-----------------

### Categories

Imports taxons in to a 'Categories' taxonomy. Creates the main Taxonomy if it doesnt exist, and creates any unknown parents

#### Usage

```bash
$ bundle exec rake csv:import:categories['/path/to/categories.csv']
```

#### CSV format

The categories import expects one column name category, with a path of the category to be created. Each level of the category should be seperated with a double slash (//)

e.g.

<table>
  <tr>
    <th>category</th>
  </tr>
  <tr>
    <td>Beer & Ale//Beer//American Beer</td>
  </tr>
  <tr>
    <td>Beer & Ale//Beer//Belgian Beer</td>
  </tr>
  <tr>
    <td>Beer & Ale//Ale//Dorset Ale</td>
  </tr>
</table>


### Product

Imports products by creating if it doesnt exist, and updating if it does. Also assigns the product to a taxon found in the categories taxonomy, it creates the taxon if it cant be found.

#### Usage

```bash
$ bundle exec rake csv:import:products['/path/to/products.csv']
```

#### CSV format

The products import expects the columns sku, price, decription, name and category. Categories should be seperated with a double slash (//)

e.g.

<table>
  <tr>
    <th>sku</th>
    <th>name</th>
    <th>price</th>
    <th>description</th>
    <th>category</th>
  </tr>
  <tr>
    <td>BUD</td>
    <td>Budweiser</td>
    <td>£1</td>
    <td>One bottle</td>
    <td>Beer & Ale//Beer//American Beer</td>
  </tr>
</table>