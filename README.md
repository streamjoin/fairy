# Fairy #

The shell scripts I ever programmed are just like little fairies who get jobs done magically. May you feel helpful with them. 

While the scripts in this repository are more or less application-specific, you may checkout the [Fairy-commons](https://github.com/streamjoin/fairy-commons) repository for common script libraries. 

## About This Repository

This repository contains [submodules](modules) as dependencies. Therefore, you should run the following command to get the complete source code: 


```sh
git clone --recursive https://github.com/streamjoin/fairy.git
```

When there are updates of the submodules at their remote repositories, use the following command to pull the changes:  

```sh
git submodule update --init --recursive
```

If local changes of the submodules need to be synchronized with their corresponding remote repositories, run the following command: 

```sh
git submodule update --init --remote
```


## Resources

Before looking into the following references, you may consider leveraging the [bootstrapping facilities](https://github.com/streamjoin/fairy-commons/blob/master/bin/README.md) crafted based on my years of experience to initiate your shell programming in a more elegant way. 

- [Google Shell Style Guide](https://google.github.io/styleguide/shell.xml)
- [Bash Guide for Beginners](https://www.tldp.org/LDP/Bash-Beginners-Guide/html/index.html) (by Machtelt Garrels)
- [Shell常用招式大全之入门篇](https://segmentfault.com/a/1190000002924882)
- [Best Practices for Writing Bash Scripts](https://kvz.io/blog/2013/11/21/bash-best-practices/) (by Kevin van Zonneveld)
- [progrium/bashstyle](https://github.com/progrium/bashstyle) (by Jeff Lindsay)
- [Bash Scripting Best Practices](https://sap1ens.com/blog/2017/07/01/bash-scripting-best-practices/) (by Yaroslav Tkachenko)
- [Bash best practices](https://bertvv.github.io/cheat-sheets/Bash.html) (by Bert Van Vreckem)
