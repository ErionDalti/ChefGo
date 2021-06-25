import 'Original.dart';

class OrderItem {
  int id;
  String design;
  String alternative_name;
  String ref_rayon;
  String ref_shipping;
  String ref_categorie;
  String restaurant_food_printed;
  String product_skip_cooking;
  String ref_provider;
  String ref_taxe;
  String order;
  String tax_type;
  String quantity;
  String sku;
  String quantite_restante;
  String hold_quantity;
  String quantite_vendu;
  String defectueux;
  String prix_dachat;
  String frais_accessoire;
  String count_dachat;
  String taux_de_marge;
  String prix_de_vente;
  String prix_de_vente_ttc;
  String prix_de_vente_brut;
  String shadow_price;
  String taille;
  String poids;
  String couleur;
  String hauteur;
  String largeur;
  String prix_promotionel;
  String special_price_start_date;
  String special_price_end_date;
  String description;
  String apercu;
  String codebar;
  String date_creation;
  String date_mod;
  String author;
  String override_stock;
  String ref_recipe;
  String type;
  String status;
  String stock_enabled;
  String stock_alert;
  String alert_quantity;
  String expiration_date;
  String on_expire_action;
  String auto_barcode;
  String barcode_type;
  String ref_modifiers_group;
  String use_variation;
  String restaurant_food_note;
  String restaurant_food_Printed;
  String restaurant_food_status;
  String discount_type;
  int discount_amount;
  int discount_percent;
  int qte_added;
  String promo_enabled;
  String iD;
  int qte_Added;
  String codeBar;
  String salePrice;
  String qte_sold;
  String qte_remaining;
  String stock_Enabled;
  String discount_Type;
  int discount_Amount;
  int discount_Percent;
  String categoryId;
  Original original;

  Object metas;
  String name;
  String alternativename;
  bool inline;
  double tax;
  double total_tax;
  String restaurant_food_issue;
  Object restaurant_food_modifiers;

  OrderItem(
      {this.id,
      this.design,
      this.alternative_name,
      this.ref_rayon,
      this.ref_shipping,
      this.ref_categorie,
      this.restaurant_food_printed,
      this.product_skip_cooking,
      this.ref_provider,
      this.ref_taxe,
      this.order,
      this.tax_type,
      this.quantity,
      this.sku,
      this.quantite_restante,
      this.hold_quantity,
      this.quantite_vendu,
      this.defectueux,
      this.prix_dachat,
      this.frais_accessoire,
      this.count_dachat,
      this.taux_de_marge,
      this.prix_de_vente,
      this.prix_de_vente_ttc,
      this.prix_de_vente_brut,
      this.shadow_price,
      this.taille,
      this.poids,
      this.couleur,
      this.hauteur,
      this.largeur,
      this.prix_promotionel,
      this.special_price_start_date,
      this.special_price_end_date,
      this.description,
      this.apercu,
      this.codebar,
      this.date_creation,
      this.date_mod,
      this.author,
      this.override_stock,
      this.ref_recipe,
      this.type,
      this.status,
      this.stock_enabled,
      this.stock_alert,
      this.alert_quantity,
      this.expiration_date,
      this.on_expire_action,
      this.auto_barcode,
      this.barcode_type,
      this.ref_modifiers_group,
      this.use_variation,
      this.restaurant_food_note,
      this.restaurant_food_Printed,
      this.restaurant_food_status,
      this.discount_type,
      this.discount_amount,
      this.discount_percent,
      this.qte_added,
      this.promo_enabled,
      this.iD,
      this.qte_Added,
      this.codeBar,
      this.salePrice,
      this.qte_sold,
      this.qte_remaining,
      this.stock_Enabled,
      this.discount_Type,
      this.discount_Amount,
      this.discount_Percent,
      this.categoryId,
      this.original,
      this.metas,
      this.alternativename,
      this.inline,
      this.name,
      this.restaurant_food_issue,
      this.restaurant_food_modifiers,
      this.tax,
      this.total_tax});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    design = json['DESIGN'];
    alternative_name = json['ALTERNATIVE_NAME'];
    ref_rayon = json['REF_RAYON'];
    ref_shipping = json['REF_SHIPPING'];
    ref_categorie = json['REF_CATEGORIE'];
    restaurant_food_printed = json['RESTAURANT_FOOD_PRINTED'];
    product_skip_cooking = json['PRODUCT_SKIP_COOKING'];
    ref_provider = json['REF_PROVIDER'];
    ref_taxe = json['REF_TAXE'];
    order = json['ORDER'];
    tax_type = json['TAX_TYPE'];
    quantity = json['QUANTITY'];
    sku = json['SKU'];
    quantite_restante = json['QUANTITE_RESTANTE'];
    hold_quantity = json['HOLD_QUANTITY'];
    quantite_vendu = json['QUANTITE_VENDU'];
    defectueux = json['DEFECTUEUX'];
    prix_dachat = json['PRIX_DACHAT'];
    frais_accessoire = json['FRAIS_ACCESSOIRE'];
    count_dachat = json['COUT_DACHAT'];
    taux_de_marge = json['TAUX_DE_MARGE'];
    prix_de_vente = json['PRIX_DE_VENTE'];
    prix_de_vente_ttc = json['PRIX_DE_VENTE_TTC'];
    prix_de_vente_brut = json['PRIX_DE_VENTE_BRUT'];
    shadow_price = json['SHADOW_PRICE'];
    taille = json['TAILLE'];
    poids = json['POIDS'];
    couleur = json['COULEUR'];
    hauteur = json['HAUTEUR'];
    largeur = json['LARGEUR'];
    prix_promotionel = json['PRIX_PROMOTIONEL'];
    special_price_start_date = json['SPECIAL_PRICE_START_DATE'];
    special_price_end_date = json['SPECIAL_PRICE_END_DATE'];
    description = json['DESCRIPTION'];
    apercu = json['APERCU'];
    codebar = json['CODEBAR'];
    date_creation = json['DATE_CREATION'];
    date_mod = json['DATE_MOD'];
    author = json['AUTHOR'];
    override_stock = json['OVERRIDE_STOCK'];
    ref_recipe = json['REF_RECIPE'];
    type = json['TYPE'];
    status = json['STATUS'];
    stock_enabled = json['STOCK_ENABLED'];
    stock_alert = json['STOCK_ALERT'];
    alert_quantity = json['ALERT_QUANTITY'];
    expiration_date = json['EXPIRATION_DATE'];
    on_expire_action = json['ON_EXPIRE_ACTION'];
    auto_barcode = json['AUTO_BARCODE'];
    barcode_type = json['BARCODE_TYPE'];
    ref_modifiers_group = json['REF_MODIFIERS_GROUP'];
    use_variation = json['USE_VARIATION'];
    restaurant_food_note = json['restaurant_food_note'];
    restaurant_food_Printed = (json['restaurant_food_printed'] == null ||
            json['restaurant_food_printed'] == "")
        ? "0"
        : json['restaurant_food_printed'];
    restaurant_food_status = json['restaurant_food_status'];
    discount_type = json['DISCOUNT_TYPE'];
    discount_amount = json['DISCOUNT_AMOUNT'];
    discount_percent = json['DISCOUNT_PERCENT'];
    qte_added = json['QTE_ADDED'];
    promo_enabled = json['PROMO_ENABLED'];
    iD = json['id'];
    qte_Added = json['qte_added'];
    codeBar = json['codebar'];
    salePrice = json['sale_price'];
    qte_sold = json['qte_sold'];
    qte_remaining = json['qte_remaining'];
    stock_Enabled = json['stock_enabled'];
    discount_Type = json['discount_type'];
    discount_Amount = json['discount_amount'];
    discount_Percent = json['discount_percent'];
    categoryId = json['category_id'];

    name = json['name'];
    alternative_name = json['alternative_name'];
    inline = json['inline'];
    tax = json['tax'];
    total_tax = json['total_tax'];
    restaurant_food_issue = json['restaurant_food_issue'];

    if (json['original'] != null) {
      original = Original.fromJson(json['original']);
    } else {
      original = null;
    }
    if (json['metas'] == null)
      metas = {};
    else
      metas = {};
    json['metas'] = {};
    if (json['restaurant_food_modifiers'] == null)
      restaurant_food_modifiers = {};
    else
      restaurant_food_modifiers = {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['ID'] = id;
    json['DESIGN'] = design;
    json['ALTERNATIVE_NAME'] = alternative_name;
    json['REF_RAYON'] = ref_rayon;
    json['REF_SHIPPING'] = ref_shipping;
    json['REF_CATEGORIE'] = ref_categorie;
    json['RESTAURANT_FOOD_PRINTED'] = restaurant_food_printed;
    json['PRODUCT_SKIP_COOKING'] = product_skip_cooking;
    json['REF_PROVIDER'] = ref_provider;
    json['REF_TAXE'] = ref_taxe;
    json['ORDER'] = order;
    json['TAX_TYPE'] = tax_type;
    json['QUANTITY'] = quantity;
    json['SKU'] = sku;
    json['QUANTITE_RESTANTE'] = quantite_restante;
    json['HOLD_QUANTITY'] = hold_quantity;
    json['QUANTITE_VENDU'] = quantite_vendu;
    json['DEFECTUEUX'] = defectueux;
    json['PRIX_DACHAT'] = prix_dachat;
    json['FRAIS_ACCESSOIRE'] = frais_accessoire;
    json['COUT_DACHAT'] = count_dachat;
    json['TAUX_DE_MARGE'] = taux_de_marge;
    json['PRIX_DE_VENTE'] = prix_de_vente;
    json['PRIX_DE_VENTE_TTC'] = prix_de_vente_ttc;
    json['PRIX_DE_VENTE_BRUT'] = prix_de_vente_brut;
    json['SHADOW_PRICE'] = shadow_price;
    json['TAILLE'] = taille;
    json['POIDS'] = poids;
    json['COULEUR'] = couleur;
    json['HAUTEUR'] = hauteur;
    json['LARGEUR'] = largeur;
    json['PRIX_PROMOTIONEL'] = prix_promotionel;
    json['SPECIAL_PRICE_START_DATE'] = special_price_start_date;
    json['SPECIAL_PRICE_END_DATE'] = special_price_end_date;
    json['DESCRIPTION'] = description;
    json['APERCU'] = apercu;
    json['CODEBAR'] = codebar;
    json['DATE_CREATION'] = date_creation;
    json['DATE_MOD'] = date_mod;
    json['AUTHOR'] = author;
    json['OVERRIDE_STOCK'] = override_stock;
    json['REF_RECIPE'] = ref_recipe;
    json['TYPE'] = type;
    json['STATUS'] = status;
    json['STOCK_ENABLED'] = stock_enabled;
    json['STOCK_ALERT'] = stock_alert;
    json['ALERT_QUANTITY'] = alert_quantity;
    json['EXPIRATION_DATE'] = expiration_date;
    json['ON_EXPIRE_ACTION'] = on_expire_action;
    json['AUTO_BARCODE'] = auto_barcode;
    json['BARCODE_TYPE'] = barcode_type;
    json['REF_MODIFIERS_GROUP'] = ref_modifiers_group;
    json['USE_VARIATION'] = use_variation;
    json['restaurant_food_note'] = restaurant_food_note;
    json['restaurant_food_printed'] =
        (restaurant_food_Printed == null || restaurant_food_Printed == "")
            ? "0"
            : restaurant_food_Printed;
    json['restaurant_food_status'] = restaurant_food_status;
    json['DISCOUNT_TYPE'] = discount_type;
    json['DISCOUNT_AMOUNT'] = discount_amount;
    json['DISCOUNT_PERCENT'] = discount_percent;
    json['QTE_ADDED'] = qte_added;
    json['PROMO_ENABLED'] = promo_enabled;
    json['id'] = iD;
    json['qte_added'] = qte_Added;
    json['codebar'] = codeBar;
    json['sale_price'] = salePrice;
    json['qte_sold'] = qte_sold;
    json['qte_remaining'] = qte_remaining;
    json['stock_enabled'] = stock_Enabled;
    json['discount_type'] = discount_Type;
    json['discount_amount'] = discount_Amount;
    json['discount_percent'] = discount_Percent;
    json['category_id'] = categoryId;

    if (this.original != null)
      json['original'] = this.original.toJson();
    else
      json['original'] = null;
    if (this.metas != null)
      json['metas'] = {};
    else
      json['metas'] = {};

    json['name'] = name;
    json['alternative_name'] = alternative_name;
    json['inline'] = inline;
    json['tax'] = tax;
    json['total_tax'] = total_tax;
    json['restaurant_food_issue'] = restaurant_food_issue;
    if (this.restaurant_food_modifiers != null)
      json['restaurant_food_modifiers'] = {};
    else
      json['restaurant_food_modifiers'] = {};
    return json;
  }
}
