file_name="actions-runner.tar.gz"
user_name="ec2-user"

mkdir -p /opt/hostedtoolcache
cd /opt/

mkdir actions-runner
cd actions-runner

echo "Downloading GitHub runner"
curl -o $file_name -L https://github.com/actions/runner/releases/download/v2.300.2/actions-runner-linux-x64-2.300.2.tar.gz
echo "Downloaded GitHub runner"

echo "Extracting GitHub runner .tar"
tar xzf ./$file_name
echo "Extracted GitHub runner .tar"

rm -rf $file_name

chown -R "$user_name":"$user_name" .
chown -R "$user_name":"$user_name" /opt/hostedtoolcache

