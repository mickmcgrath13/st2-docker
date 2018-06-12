# Tutorial for Bitovi pack developmnet

Bitovi StackStorm Docker comes with the following packs:
- [bitvoi_packs](https://github.com/bitovi-stackstorm-exchange/bitvoi_packs)
- [github](https://github.com/bitovi-stackstorm-exchange/github)


## Create a new pack
- `bitovi_packs.create`
    - **IMPORTANT!!!** Always use underscore (`_`) delimited pack names (e.g. `my_pack` and **NOT** `my-pack`).  Everyone will just be happier if you do ;)
- `cd bitovi-stackstorm-exchange && git clone https://path/to/my_pack && cd my_pack`


## Pack Development

To get local changes into the system, you need to commit your changes locally (no need to push) and then run the `bitovi_packs.install` action with value of `file:////opt/stackstorm/bitovi-stackstorm-exchange/my_pack`.

Packs that have been created with `bitovi_packs.create` and installed into `bitovi-stackstorm-exchange/` directory will automatically re-install from the local pack folder when you commit your changes locally (no need to manually reinstall)

For more information on developing with packs
- [StackStorm Docs](http://docs.stackstorm.com/)
- [Original StackStorm tutorial](./tutorial.md)


## Pack Promotion
How to get packs from one environment to another

**TODO**