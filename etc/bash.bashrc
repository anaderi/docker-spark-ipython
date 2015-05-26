source /opt/rh/python27/enable
if [ -n "$PASSWD" ] ; then
  python -c "from IPython.lib import passwd; print passwd('$PASSWD')"  > /root/.ipython/profile_default/nbpasswd.txt
fi
