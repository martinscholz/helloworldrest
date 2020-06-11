echo off
mkdir tmp
cls
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                  
echo                                                     iiii                                                                                                               tttt                222222222222222    555555555555555555 
echo                                                    i::::i                                                                                                           ttt:::t               2:::::::::::::::22  5::::::::::::::::5 
echo                                                     iiii                                                                                                            t:::::t               2::::::222222:::::2 5::::::::::::::::5 
echo                                                                                                                                                                     t:::::t               2222222     2:::::2 5:::::555555555555 
echo   aaaaaaaaaaaaa      ssssssssss       ssssssssss   iiiiiii    ggggggggg   gggggnnnn  nnnnnnnn        eeeeeeeeeeee       mmmmmmm    mmmmmmm   nnnn  nnnnnnnn    ttttttt:::::ttttttt                     2:::::2 5:::::5            
echo   a::::::::::::a   ss::::::::::s    ss::::::::::s  i:::::i   g:::::::::ggg::::gn:::nn::::::::nn    ee::::::::::::ee   mm:::::::m  m:::::::mm n:::nn::::::::nn  t:::::::::::::::::t                     2:::::2 5:::::5            
echo   aaaaaaaaa:::::ass:::::::::::::s ss:::::::::::::s  i::::i  g:::::::::::::::::gn::::::::::::::nn  e::::::eeeee:::::eem::::::::::mm::::::::::mn::::::::::::::nn t:::::::::::::::::t                  2222::::2  5:::::5555555555   
echo            a::::as::::::ssss:::::ss::::::ssss:::::s i::::i g::::::ggggg::::::ggnn:::::::::::::::ne::::::e     e:::::em::::::::::::::::::::::mnn:::::::::::::::ntttttt:::::::tttttt             22222::::::22   5:::::::::::::::5  
echo     aaaaaaa:::::a s:::::s  ssssss  s:::::s  ssssss  i::::i g:::::g     g:::::g   n:::::nnnn:::::ne:::::::eeeee::::::em:::::mmm::::::mmm:::::m  n:::::nnnn:::::n      t:::::t                 22::::::::222     555555555555:::::5 
echo   aa::::::::::::a   s::::::s         s::::::s       i::::i g:::::g     g:::::g   n::::n    n::::ne:::::::::::::::::e m::::m   m::::m   m::::m  n::::n    n::::n      t:::::t                2:::::22222                    5:::::5
echo  a::::aaaa::::::a      s::::::s         s::::::s    i::::i g:::::g     g:::::g   n::::n    n::::ne::::::eeeeeeeeeee  m::::m   m::::m   m::::m  n::::n    n::::n      t:::::t               2:::::2                         5:::::5
echo a::::a    a:::::assssss   s:::::s ssssss   s:::::s  i::::i g::::::g    g:::::g   n::::n    n::::ne:::::::e           m::::m   m::::m   m::::m  n::::n    n::::n      t:::::t    tttttt     2:::::2             5555555     5:::::5
echo a::::a    a:::::as:::::ssss::::::ss:::::ssss::::::si::::::ig:::::::ggggg:::::g   n::::n    n::::ne::::::::e          m::::m   m::::m   m::::m  n::::n    n::::n      t::::::tttt:::::t     2:::::2       2222225::::::55555::::::5
echo a:::::aaaa::::::as::::::::::::::s s::::::::::::::s i::::::i g::::::::::::::::g   n::::n    n::::n e::::::::eeeeeeee  m::::m   m::::m   m::::m  n::::n    n::::n      tt::::::::::::::t     2::::::2222222:::::2 55:::::::::::::55 
echo  a::::::::::aa:::as:::::::::::ss   s:::::::::::ss  i::::::i  gg::::::::::::::g   n::::n    n::::n  ee:::::::::::::e  m::::m   m::::m   m::::m  n::::n    n::::n        tt:::::::::::tt     2::::::::::::::::::2   55:::::::::55   
echo   aaaaaaaaaa  aaaa sssssssssss      sssssssssss    iiiiiiii    gggggggg::::::g   nnnnnn    nnnnnn    eeeeeeeeeeeeee  mmmmmm   mmmmmm   mmmmmm  nnnnnn    nnnnnn          ttttttttttt       22222222222222222222     555555555     
echo                                                                        g:::::g                                                                                                                                                    
echo                                                            gggggg      g:::::g                                                                                                                                                    
echo                                                            g:::::gg   gg:::::g                                                                                                                                                    
echo                                                             g::::::ggg:::::::g                                                                                                                                                    
echo                                                              gg:::::::::::::g                                                                                                                                                     
echo                                                                ggg::::::ggg                                                                                                                                                       
echo                                                                   gggggg                                                                                                                                                          
echo. 
echo on
REM  Build a simple Java application with a REST API, 
echo cleaning up first ....
call kubectl delete service helloworld
call kubectl get services
call kubectl delete namespaces scholzma


echo compiling sources
echo.

call mvn install

REM gathering sources and configs
move .\target\helloworldrest-0.0.1-SNAPSHOT.jar .\tmp\
copy .\deployment\* .\tmp\

cd tmp
rm *

REM create a Dockerfile
REM build it with the jar

call docker build --rm --force-rm --tag docker.at41tools.k8s.aws.msgoat.eu/cxp/helloworldrest-scholzma .

REM tag it
call docker tag docker.at41tools.k8s.aws.msgoat.eu/cxp/helloworldrest-scholzma:latest docker.at41tools.k8s.aws.msgoat.eu/cxp/helloworldrest-scholzma:0.0.1

REM creating samples manifest files
call kubectl create deployment demo --image=docker.at41tools.k8s.aws.msgoat.eu/cxp/helloworldrest-scholzma:0.0.1 --dry-run=client -o=yaml > deployment_generated.yaml
call kubectl create service nodeport helloworld --tcp=8080:8080 --dry-run=client -o=yaml > service_generated.yaml


cd ..

REM push it
REM call docker login -u cxp-pusher docker.at41tools.k8s.aws.msgoat.eu
call docker push docker.at41tools.k8s.aws.msgoat.eu/cxp/helloworldrest-scholzma:0.0.1


REM - deploy it to your personal namespace on CXP Kubernetes 



call kubectl create -f .\tmp\namespace.yaml

call kubectl create -f .\tmp\networkpolicy.yaml

REM call kubectl delete  -f .\tmp\deployment.yaml -f .\tmp\service.yaml -f .\tmp\ingress.yaml 
REM call kubectl create  -f .\tmp\deployment.yaml -f .\tmp\service.yaml -f .\tmp\ingress.yaml 

call kubectl apply  -f .\tmp\deployment.yaml -f .\tmp\service.yaml -f .\tmp\ingress.yaml 


call kubectl get namespace -o wide

call kubectl get pods -o wide

call kubectl get endpoints -o wide

call kubectl get services -o wide

call kubectl describe ingress
 
call kubectl describe svc helloworld

