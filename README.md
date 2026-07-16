[README.md](https://github.com/user-attachments/files/26223558/README.md)
# Fusion Force | Adding more fusions to Balatro

Requires Fusion Jokers mod (https://github.com/wingedcatgirl/Fusion-Jokers)

Currently contains 80+ fusions using Vanilla Jokers! That's a fusion for every single vanilla (non-legendary) Joker!

Cross-Mod content:
- Ortalab has 10+ fusions! (Also artist credit display for the individual cards)
- CardSleeves (One Sleeve version of the deck)
- Partner with 20+ new choices, and compatibility with base ones
- Tsunami (One gold fusion. Mostly excludes this mod because Splash having so many fusions causes the shop and collection wiggle to go nuts. Shadow spectral also ignores Splash or else it would generate that a LOT. Also Tsunami has a dedicated spectral for Splash already.)

## changelog

V1.3.1

### Bugfixes:
It took until now for me to realize that `= {}` and `= nil` are NOT the same thing. That's why Magnetize was causing crashes.

Suitable price not updating quickly enough fixed.

Shadowman now works within booster packs.

Voucher code reworked as they seemed to have stopped working to remove stickers at some point.

Ratio Road now correctly displays the Xmult it gives and the amount of Enhanced cards needed.


### Balance:
Gold Fusions can now be disabled in the config.

Two Heads has been restored to an older version that is now worth using even when you don't have any other fused cards.

Nice has been buffed to have it's 1/9 chance now give a booster pack tag instead of a random card.

Shadowman now changes effect if you get an extra.

Hybrid Fusion no longer gives Mult or destroys cards, it instead creates a random card and adds it to your hand face down if you play more than 3 on your first turn.

Cut and Paste Joker might have been giving 1 retrigger even when using a full hand, this has been changed to give no retriggers in that situation to fit it's description, as was always intended.

### Other:
Moorstone renamed to Geode Joker and given new art.

Straight Man art redone.

### Added Content:
- Fusions: Millstone, Fortified Joker, Easter Egg, Missing Poster, Extortion, Taurus, Torus, Full of Stars, Circus Tickets, Comeback, Colour Guard, The Aristocrats, Cactus Juice, Golden Bantam, Half & Half Joker, Molotov Cocktail

- Triple Fusions: Midas Joker

- Partners: Divine, Build, Hydra

- Gold Fusions: Two Heads, Cactus Juice

- Secret Fusions: ****

### Remaining Bugs:
Divine Partner can on rare occasion refund $1 on rerolls after buying a free planet. Onward Partner cannot display a message to show it lost Chips, any attempt to make it do so gives nonsense "card = nil" crashes. Rewards Card probably negates other debt based jokers. Bargaining Chips doesn't show confirmation message of the blind being counted. Card Collection says "+1 Joker" even when it gives +2. Having 3 cards that can all fuse with each to make 3 different fusions bugs out the fusion selection and prevents any from being fused.
