# TRM: Trade Route Modifiers
> 为文明、领袖等带有TraitModifier的能力绑定商路加成
> 
> 使用搭积木的方式组合商路加成，使用更为简易，且具有一定的拓展性
> 

# 使用方法
> 新建商路加成分为以下几个步骤：
>
> 1. 新建TradeRouteModifier，设置基本的参数，包括 ***商路方向***、 ***受益城市***和 ***商路类型***
> 2. 设置TradeRouteModifier参数Arguments
> 3. 为该Modifier或参数Arguments设置额外信息，包括且不限于Filter、Reqs
> 4. 绑定到Trait

## 1. 新建`TradeRouteModifier` `TRM`
```SQL
CREATE TABLE "TRM_TradeRouteModifier" (
TradeRouteModifier TEXT NOT NULL,
TradeRouteDirection INTEGER DEFAULT 0,
BenefitCity INTEGER DEFAULT 0,
TradeRouteType INTEGER DEFAULT 0,
PRIMARY KEY(TradeRouteModifier)
);
```
> 如上所示，表`TRM_TradeRouteModifier`共有4个字段
>
> 主键`TradeRouteModifier`为设置的TRM名，建议采用易读不易冲突的命名
> 
> 1. `TradeRouteDirection`表示该条商路的方向，分为`0: 输入或输出, 1: 输出, 2: 输入`
> 
> 2. `BenefitCity`表示该条商路加成的受益城市，分为`0: 起点和终点城市, 1: 起点城市, 2: 终点城市`
>
> 3. `TradeRouteType`表示该条商路的类型，分为`0: 国内或国际, 1: 国内, 2: 国际`
>
> 在该表插入一条记录视为创建一个TRM，并用参数该商路的基本信息。参见下例：
> 
> 表示为该商路加成适用于`输入的国际贸易路线，为贸易终点城市提供额外加成`

```SQL
INSERT INTO TRM_TradeRouteModifier(TradeRouteModifier, TradeRouteDirection, BenefitCity, TradeRouteType)
VALUES
('TRADE_ROUTE_MODIFIER_1', 2,2,2);
```

## 2. 补充`TradeRouteModifierArguments` `TRM_Arguments`
```SQL
CREATE TABLE "TRM_TradeRouteModifierArguments" (
TradeRouteModifier TEXT NOT NULL,
Name TEXT NOT NULL,
Value TEXT NOT NULL,
FOREIGN KEY(TradeRouteModifier) REFERENCES TRM_TradeRouteModifier(TradeRouteModifier)
);
```
> 如上所示，表`TRM_TradeRouteModifierArguments`共有3个字段
>
> 不包含主键，但`TradeRouteModifier`外键绑定自表`TRM_TradeRouteModifier`，因此该表为`TRM`的补充信息。用于表示`TRM`商路加成的更多参数信息，例如收益类型、收益数量、受益数量的计算方法等。
>
> `TRM_Arguments`的信息如下进行记录，其中`Name`为参数名，`Value`为参数值：
>
> 1. `CalculationType`为商路加成计算方式，默认为`直接加成`，即直接在商路中增加参数中的`YieldType Amount`。更多计算类型参见下文详细说明。
> 
> 2. `YieldType`为商路加成类型，可参见官方表`Yields`，多种加成类型使用`,`隔开,例：`YIELD_GOLD,YIELD_PRODUCTION`。
> 
> 3. `Amount`为商路加成数量，一般和`YieldType`对应，只可使用整数。对应多个加成类型时也可使用`,`进行分别对应。例：`2,3`对应上文即为，`+2金币、+3生产力`。也可使用单数字来对应对个加成类型，例：`1`对应上文即为，`+1金币、+1生产力`。
>
> 4. `Filter`等额外说明，对应特殊`CalculationType`，用于在计算加成数量时进行过滤或其他操作。参见下文详细说明。
>
> 一般在该表中需要为`TRM`插入多条`Arguments`。参见下例：
>
> 表示`TRADE_ROUTE_MODIFIER...`采用`ORIGINATION_CITY_EACH_RESOURCE（起始城市每个资源）`计算加成时使用`FILTER_RESOURCE_DEER（资源：鹿）`过滤，并根据过滤出的数量提供`+2信仰值`。

```SQL
INSERT INTO TRM_TradeRouteModifierArguments(TradeRouteModifier, Name, Value)
VALUES
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'CalculationType', 'ORIGINATION_CITY_EACH_RESOURCE'),
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'Filter', 'FILTER_RESOURCE_DEER'),
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'YieldType', 'YIELD_FAITH'),
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'Amount', '2');
```

## 3. 额外信息
> 为`TRM`或`TRM_Arguments`绑定额外参数，详见下文。
## 4. 绑定Trait
```SQL
CREATE TABLE "TRM_TraitTradeRouteModifier" (
TraitType TEXT NOT NULL,
TradeRouteModifier TEXT NOT NULL,
FOREIGN KEY(TraitType) REFERENCES Traits(TraitType),
FOREIGN KEY(TradeRouteModifier) REFERENCES TRM_TradeRouteModifier(TradeRouteModifier)
);
```
> 表`TRM_TraitTradeRouteModifier`用于为`Trait`绑定`TRM`
>
> `TraitType`外键绑定自官方表`Traits`，`TradeRouteModifier`外键绑定自表`TRM_TradeRouteModifier`
>
> 在此表中，将`TRM`和`Trait`绑定后，在游戏中拥有`Trait`的目标即可拥有商路加成。


# 额外说明

## CalculateType

## Filter

### GameInfo/官方数据库

### Custom/特殊
1. `CityReligionFollowersType`/`宗教信徒类型`
> `ALL - 全部宗教`
> 
> `DOMINANT - 主流宗教`
>
> `FOUNDER - 创建者`

2. `CityCenterDistanceRange`/`距离市中心单元格范围`
> `City,Min,Max`
>
> `ORIGINATION,3,999`/`(起始城市,最小距离=3,最大距离=999)`

3. `IsImproved`/`是否改良`
> `0: 未改良`/`1: 已改良`

4. `WonderBuiltType`/`奇观建造类型`
> `NATURAL: 自然`/`MANMADE: 人造`/`Incomplete: 未完成` 

## Reqs
> `TRM_TradeRouteModifierRequirements(Requirement, RequirementType, Name, Value, Inverse)`
### `RequirementType`
#### `Preload`
1. `CityIsOriginalOwner`/`起始终点城市拥有者非原始创建者`
> `ANY`|`起终任意玩家`
> 
> `ALL`|`起始终点均非原始创建者`
> 
> `ORIGINATION`|`起始城市`
> 
> `DESTINATION`|`终点城市`
>
2. `DestinationPlayerType`/`终点城市拥有者玩家类型`
> `Minor`|`Major`|`AI`|`Human`
> 
> `城邦`|`文明`|`AI`|`人类玩家`
#### `Onload`
1. `DestinationCityRelationship`/`终点城市与起始城市玩家关系`
> `Ally|Suzerain`


## ExtraMutilpier/额外加成倍数

1. `Suzerain`/`宗主国加成（仅贸易起/终点为城邦时生效）`
> `0: 非宗主国`/`N: 为宗主国 & 加成*整数N倍`


# 示例
> 示例中包含对官方能力的复刻，和一些测试性能力。
>

## 官方能力复刻
1. 庞德梅克
> `输出的贸易路线` `目的地城市中的每座营地或牧场`可`为庞德梅克（起始城市）提供+1食物`。
> 
> `输入的国外贸易路线` `目的地城市中的每座营地或牧场`可`为庞德梅克（终点城市）提供+1金币`。
```SQL
-- TRM
('TRADE_ROUTE_MODIFIER_FOOD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 1,1,0),
('TRADE_ROUTE_MODIFIER_GOLD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 2,2,0)
-- TRM_Arguments
('TRADE_ROUTE_MODIFIER_FOOD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'CalculationType', 'DESTINATION_CITY_EACH_IMPROVEMENT'),
('TRADE_ROUTE_MODIFIER_FOOD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'Filter', 'FILTER_IMPROVEMENT_CAMP_PASTURE'),
('TRADE_ROUTE_MODIFIER_FOOD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'YieldType', 'YIELD_FOOD'),
('TRADE_ROUTE_MODIFIER_FOOD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'Amount', '1'),

('TRADE_ROUTE_MODIFIER_GOLD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'CalculationType', 'DESTINATION_CITY_EACH_IMPROVEMENT'),
('TRADE_ROUTE_MODIFIER_GOLD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'Filter', 'FILTER_IMPROVEMENT_CAMP_PASTURE'),
('TRADE_ROUTE_MODIFIER_GOLD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'YieldType', 'YIELD_GOLD'),
('TRADE_ROUTE_MODIFIER_GOLD_FROM_DESTINATION_CITY_EACH_IMPROVEMENT', 'Amount', '1'),
-- Filter
('FILTER_IMPROVEMENT_CAMP_PASTURE', 'GameInfo', 'ImprovementType', 'IMPROVEMENT_CAMP,IMPROVEMENT_PASTURE')
```
2. ...

## 自定义能力
1. **输入**的**国际贸易路线**，**起始城市**中的**每个鹿资源**可**为终点城市提供+2信仰值**

```SQL
INSERT INTO TRM_TradeRouteModifier(TradeRouteModifier, TradeRouteDirection, BenefitCity, TradeRouteType)
VALUES
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 2,2,2);

INSERT INTO TRM_TradeRouteModifierArguments(TradeRouteModifier, Name, Value)
VALUES
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'CalculationType', 'ORIGINATION_CITY_EACH_RESOURCE'),
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'Filter', 'FILTER_RESOURCE_DEER'),
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'YieldType', 'YIELD_FAITH'),
('TRADE_ROUTE_MODIFIER_ORIGINATION_CITY_EACH_RESOURCE_DEER', 'Amount', '2');

INSERT INTO TRM_TradeRouteModifierFilters(Filter, FilterType, Name, Value)
VALUES
('FILTER_RESOURCE_DEER', 'GameInfo', 'ResourceType', 'RESOURCE_DEER');
```

2. ...


# 报警、错误相关
> 报警错误一般请参考游戏缓存目录下的`Lua.log`文件，一般目录为`C:\Users\$User$\AppData\Local\Firaxis Games\Sid Meier's Civilization VI\Logs\Lua.log`，其中`$User$`替换为个人账户名。

# 其他与鸣谢
> 该MOD脱胎于为[`鳗鱼娘MOD`](https://steamcommunity.com/sharedfiles/filedetails/?id=3032610370)新增内容时的一个想法💡，在那个MOD中采用的是`Plot Property`和`Modifier`的配合，通过SQL新建100+条Modifier并全部绑定在市中心Plot中，然后通过Property来开关对应数量的Modifer，局限性很大。
>
> 所幸工坊中出现了大救星，即为该MOD实现提供可能性的[`碧蓝航线·DLL核心`](https://steamcommunity.com/sharedfiles/filedetails/?id=3390077305),在此需要特别感谢[`PhantomJ_M`](https://steamcommunity.com/id/PhantomJ_M)和[`HSbF6HSO3F`](https://steamcommunity.com/profiles/76561199351838188)两位贡献者，可以说没有技术基石，再多的想法也无法实现。
>
> 在此DLL MOD的基础上，可以动态为`Player、City`添加移除`Modifier`，这极大程度上实现了操作和代码的可能性。