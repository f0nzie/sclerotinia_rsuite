# rsuite: re-creating sclerotinia project


This is the reconstruction of the project **sclerotinia** by using the R package `rsuite`. This package along with its command line client `rsuite`, allows to build complex projects and customize the way the projects are built. This eliminates the curent rigid structure to build projects and packages, focusing in the deployment of the solution.

> Use the R version corresponding to the major version number of the project. For instance, `353.0.1`, use `R-3.5.3`, or `360.0.2` for `R-3.6.0`.

The original **sclerotinia** project that is built via `make` is located in Github here:

<https://github.com/everhartlab/sclerotinia-366>

## Scripts
There are three scripts that assist in building the project documents, figures and datasets:

* `R/compile_rmd.R`
* `R/compile_manuscript.R`
* `R/tidy.R`

Execute these commands from the command line.
Example:

```
Rscript R\compile_rmd.R --which="01.Rmd"
```

or 

```
Rscript R\compile_rmd.R --which="all"
```

Then:

```
Rscript R\compile_manuscript.R
```

to compile the manuscript.


## File locations
All the notebooks that generate figures and tables for the manuscript are located under `doc/RMD`. The manuscript auxiliary files such as bibliography and Latex classes are located under `doc/manuscript`. The final document `manuscript.pdf` will be located here as well.

The intermediate files that are used to build the manuscript are located under the folder `results`.

There are only two data files that are required to build the rest of the datasets. These two files are located under the folder `data/raw`.

Addionally, a package `ScleroWorld`, that provides all the packages dependencies for the **sclerotinia** project is located under `packages/ScleroWorld`.


## Build a `rsuite` template

An `rsuite` project can be a project and a package. In this case, we will create the project template and then we create the package template.

**Create a project template**

```
rsuite tmpl start -n sclero_template --prj
```



**Add a package  template**

```
rsuite tmpl start -n sclero_template --pkg
```



**Add a package to a project based on a template**

This uses the template `sclero_template` to add a package to project `sclero_project` .

```
cd sclero_project
rsuite proj pkgadd -n ScleroWorld -t sclero_template
cd ..
```




**Register a template with rsuite**

This is after finishing with changes in the template. It has to be done as many times as changes are made.

```
rsuite tmpl register -p sclero_template
```



## Create project and package from a template

**Create a project from the template**

```
rsuite proj start -n sclero_project -t sclero_template
```



**Add a package inside a project**

This will use the package template.

````
cd sclero_project
rsuite proj pkgadd -n ScleroWorld -t sclero_template
cd ..
````



## Install dependencies

**Install the dependencies**

```
rsuite proj depsinst
```



## Build the project

```
rsuite proj build
```



## Run the application

### Compile the notebooks

```
Rscript R\compile_rmd.R --which="all"
```

### Compile one notebook

```
Rscript R\compile_rmd.R --which="02.Rmd"
```

### Compile the Manuscript

```
Rscript R\compile_manuscript.R
```



**Initialize a repository in the local drive**

```
rsuite repo init -d R:\myrepo
```



## Arguments from the command line

This code handles with the arguments.

```
# function to handle what to do with the arguments
kniter <- function(which) {
  if (which == "all") {
    print(rmd_files)
    rmd_built <- rmd_files
    knit_rmd(rmd_built)
  } else {
    print(which)
    rmd_built <- which
    knit_rmd(which)
  }
  rmd_built
}

# retrieve the arguments from the command line
rmd_built <- kniter(
  which = args$get(name = "which", required = FALSE, default = "all")
  )
```

Use this to pass the arguments from the command line:

```
Rscript R\compile_rmd.R --which="all"
```

or to build only one notebook:

```
Rscript R\compile_rmd.R --which="06.Rmd"
```





## Tips

* After each modification in the templates, the master template need to be re-registered.
* When a new project is started or initialized, all the packages called in the package are installed in the folder \__Project\__/deployment/sbox
* Remember to call the main package from the project R scripts. That causes to load any package required in the project.
* Be aware of the chunks with `cache=TRUE`. Sometimes the cache causes calls to libraries to be ignored until the cache is renewed.
* If a package is not in CRAN or MRAN and is proving difficult to call, then download the source and put it under the `packages` folder. Then, tests its dependencies.



## References

<https://rsuite.io/RSuite_Tutorial.php?article=rsuite_cli_reference.md#adding-external-packages-to-repository>

<https://github.com/GuangchuangYu/treeio>

