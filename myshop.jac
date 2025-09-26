"""Shop Inventory"""

node Item {
    has name: str;
    has price: int;
}

node Category {
    has name: str;
}

walker ShopBrowser {
    # make query optional (default = "")
    has query: str = "";

    can start with `root entry;
    can search with `root entry;
}

# CLI entrypoint: create the graph (categories -> items) and spawn the walker
with entry:__main__ {
    # Phone Chargers
    let phone = root ++> Category("Phone Chargers");
    phone ++> Item("Samsung Fast Charger", 1200);
    phone ++> Item("iPhone Charger", 2000);
    phone ++> Item("Type-C Charger", 800);
    phone ++> Item("Infinix Charger", 700);
    phone ++> Item("Oppo Charger", 900);

    # USB Cables
    let cables = root ++> Category("USB Cables");
    cables ++> Item("Type-C Cable", 300);
    cables ++> Item("iPhone Lightning Cable", 1200);
    cables ++> Item("Micro-USB Cable", 200);
    cables ++> Item("Fast Charge Cable", 500);
    cables ++> Item("Braided USB Cable", 600);

    # Flash Disks
    let flash = root ++> Category("Flash Disks");
    flash ++> Item("SanDisk 16GB", 800);
    flash ++> Item("SanDisk 32GB", 1200);
    flash ++> Item("HP 64GB", 2000);
    flash ++> Item("Kingston 16GB", 700);
    flash ++> Item("Sony 32GB", 1500);

    # Earphones
    let ear = root ++> Category("Earphones");
    ear ++> Item("Samsung Earphones", 500);
    ear ++> Item("Apple Earpods", 2500);
    ear ++> Item("Infinix Earphones", 400);
    ear ++> Item("Wireless Earbuds", 3500);
    ear ++> Item("Bass Boost Earphones", 1500);

    # Spawn walker (no args needed now)
    root spawn ShopBrowser();
}

impl ShopBrowser.start {
    print("\n Welcome to My Electrical Shop!");
    if not [root --> (`?Category)] {
        print("No categories available.");
        disengage;
    }

    for c in [root --> (`?Category)] {
        print("\n--- " + c.name + " ---");
        if [c --> (`?Item)] {
            for itm in [c --> (`?Item)] {
                print("- " + itm.name + " (Ksh " + str(itm.price) + ")");
            }
        } else {
            print("- (no items)");
        }
    }

    disengage;
}

impl ShopBrowser.search {
    print("\n Searching for: " + self.query);
    let found = 0;

    if not [root --> (`?Category)] {
        print("No categories available.");
        disengage;
    }

    for c in [root --> (`?Category)] {
        if [c --> (`?Item)] {
            for itm in [c --> (`?Item)] {
                if self.query in itm.name {
                    print("Found: " + itm.name + " (Ksh " + str(itm.price) + ")");
                    found = 1;
                }
            }
        }
    }
}
