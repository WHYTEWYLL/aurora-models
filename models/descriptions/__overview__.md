{% docs __overview__ %}

# Welcome to the Flipside Crypto Aurora Models Documentation

## **What does this documentation cover?**

The documentation included here details the design of the Aurora
tables and views available via [Flipside Crypto.](https://flipsidecrypto.xyz/) For more information on how these models are built, please see [the github repository.](https://github.com/flipsideCrypto/aurora-models/)

## **How do I use these docs?**

The easiest way to navigate this documentation is to use the Quick Links below. These links will take you to the documentation for each table, which contains a description, a list of the columns, and other helpful information.

If you are experienced with dbt docs, feel free to use the sidebar to navigate the documentation, as well as explore the relationships between tables and the logic building them.

There is more information on how to use dbt docs in the last section of this document.

## **Quick Links to Table Documentation**

**Click on the links below to jump to the documentation for each schema.**

### Core Tables (`AURORA`.`CORE`.`<table_name>`)

**Fact Tables:**

- [fact_blocks](#!/model/model.aurora.core__fact_blocks)
- [fact_transactions](#!/model/model.aurora.core__fact_transactions)
- [fact_logs](#!/model/model.aurora.core__fact_logs)
- [fact_receipts](#!/model/model.aurora.core__fact_receipts)

## **⚠️ Aurora Data Notes and Known Issues**

Update: July 26, 2023:

We're thrilled to announce that, in collaboration with Aurora, we're nearing a solution to the issues concerning Duplicated Transactions and Reverted Transactions. As a reminder, Reverted Transactions are transactions or events that were previously cancelled or reverted but are still being received from the chain.

Aurora team is confident that these issues will be fully resolved by the end of this week or at the latest, early next week.

Rest assured, the Flipside team is on top of the situation. As soon as the problem is resolved, we will promptly adapt our model and provide an update. Thank you for your patience as we continuously strive to improve our service.

## **Data Model Overview**

The Aurora models are built a few different ways, but the core fact tables are built using three layers of sql models: **bronze, silver, and gold (or core).**

- Bronze: Data is loaded in from the source as a view
- Silver: All necessary parsing, filtering, de-duping, and other transformations are done here
- Gold (or core): Final views and tables that are available publicly

The dimension tables are sourced from a variety of on-chain and off-chain sources.

Convenience views (denoted `ez_`) are a combination of different fact and dimension tables. These views are built to make it easier to query the data.

## **Using dbt docs**

### Navigation

You can use the `Project` and `Database` navigation tabs on the left side of the window to explore the models in the project.

### Database Tab

This view shows relations (tables and views) grouped into database schemas. Note that ephemeral models are _not_ shown in this interface, as they do not exist in the database.

### Graph Exploration

You can click the blue icon on the bottom-right corner of the page to view the lineage graph of your models.

On model pages, you'll see the immediate parents and children of the model you're exploring. By clicking the Expand button at the top-right of this lineage pane, you'll be able to see all of the models that are used to build, or are built from, the model you're exploring.

Once expanded, you'll be able to use the `--models` and `--exclude` model selection syntax to filter the models in the graph. For more information on model selection, check out the [dbt docs](https://docs.getdbt.com/docs/model-selection-syntax).

Note that you can also right-click on models to interactively filter and explore the graph.

### **More information**

- [Flipside](https://flipsidecrypto.xyz/)
- [Velocity](https://app.flipsidecrypto.com/velocity?nav=Discover)
- [Tutorials](https://docs.flipsidecrypto.com/our-data/tutorials)
- [Github](https://github.com/FlipsideCrypto/aurora-models)
- [What is dbt?](https://docs.getdbt.com/docs/introduction)

{% enddocs %}
