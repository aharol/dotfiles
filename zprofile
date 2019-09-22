# See following for more information: http://www.infinitered.com/blog/?p=19

# Path ------------------------------------------------------------
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:$PATH  # OS-X Specific, with MacPorts installed
export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH
export PATH=$HOME/Library/Python/3.6/bin:$PATH

export WORKSPACE=$HOME/Workspace

export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=1024m -XX:ReservedCodeCacheSize=1024m"

export PYTHONPATH=/usr/local/lib/python3.7/site-packages

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

export SCALA_HOME=/usr/local/Cellar/scala/2.12.8/libexec
# export SCALA_HOME=/usr/local/Cellar/scala@2.11/2.11.12/libexec
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

export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$WORKSPACE/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

export NVM_DIR=$HOME/.nvm
[ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh  # This loads nvm

# Load in .bashrc -------------------------------------------------
source ~/.zshrc

source /Users/aharol/.nix-profile/etc/profile.d/nix.sh

export PATH="$HOME/.cargo/bin:$PATH"
