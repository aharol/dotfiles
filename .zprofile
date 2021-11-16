# See following for more information: http://www.infinitered.com/blog/?p=18

# Path ------------------------------------------------------------
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:$PATH  # OS-X Specific, with MacPorts installed
export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH
export PATH=$HOME/Library/Python/3.7/bin:$PATH

export WORKSPACE=$HOME/Workspace

export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=1024m -XX:ReservedCodeCacheSize=1024m"

export PYTHONPATH=/usr/local/lib/python3.7/site-packages

# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH

# export SCALA_HOME=/usr/local/Cellar/scala/2.12.8/libexec
export SCALA_HOME=/usr/local/Cellar/scala@2.12/2.12.10/libexec
export CLASSPATH=$CLASSPATH:$SCALA_HOME/lib
export PATH=$PATH:$SCALA_HOME/bin

export SPARK_HOME=/usr/local/lib/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export CLASSPATH=$CLASSPATH:$SPARK_HOME/jars:$SPARK_HOME/external
export PYSPARK_PYTHON=python3
export PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python

export ZEPPELIN_HOME=/usr/local/lib/zeppelin
export CLASSPATH=$CLASSPATH:$ZEPPELIN_HOME/lib
export PATH=$PATH:$ZEPPELIN_HOME/bin

# export GOROOT=/usr/local/opt/go/libexec
# export GOPATH=$WORKSPACE/go
# export PATH=$PATH:$GOROOT/bin
# export PATH=$PATH:$GOPATH/bin

export NVM_DIR=$HOME/.nvm
[ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh  # This loads nvm

# Load in .bashrc -------------------------------------------------
source ~/.zshrc

export PATH="$HOME/.cargo/bin:$PATH"

#export ALL_PROXY="proxy.dmz.ace:3128"
export HTTP_PROXY="proxy.dmz.ace:3128"
export HTTPS_PROXY="proxy.dmz.ace:3128"
export NO_PROXY="127.0.0.1,localhost,*.ace,minio-production.prd.ace"

export AIRFLOW_HOME=$HOME/airflow
#source $HOME/.nix-profile/etc/profile.d/nix.sh

# PYENV
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
