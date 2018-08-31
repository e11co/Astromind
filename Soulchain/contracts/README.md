##Here is the smart contract of Astrobaby
### **The contract contains the following features:**

-  User registration / login
-  The composition and creation of astroegg
-  Astroegg's trading
-  The composition and creation of astrobaby

##Inheritance relationship between contracts

>	**AccessControl.sol is ownable.sol**
>	**RegisterloginBase.sol is AccessControl.sol**
>	**Register.sol is RegisterloginBase.sol**
>	**Login.sol is Register.sol**

---
>	**Token.sol is ERC20Interface.sol,AccessControl.sol**
>	**AstroBabyCoin.sol is Token.sol**
>	**EggBase.sol is AccessControl.sol**
>	**AstroEggBirth.sol is EggBase.sol**
>	**EggOwnerShip.sol is AstroEggBirth.sol , AstroBabyCoin.sol**
	
	

