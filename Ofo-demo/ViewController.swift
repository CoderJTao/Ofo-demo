//
//  ViewController.swift
//  Ofo-demo
//
//  Created by jiangT on 2017/7/13.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import FTIndicator

class ViewController: UIViewController {

    var nearBySearch = true
    
    //高德地图显示地图
    var mapView : MAMapView!
    //搜索
    var search : AMapSearchAPI!
    //自定义大头针
    var pin : MyPinAnnotation!
    var pinView : MAPinAnnotationView?
    //导航管理
    var walkManager : AMapNaviWalkManager!
    var start, end : CLLocationCoordinate2D!
    
    
    @IBOutlet var functionView: UIView!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var wrongBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        //地图
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        view.insertSubview(mapView, belowSubview: functionView)
        mapView.delegate = self
        
        mapView.showsScale = false
        mapView.showsCompass = false
        mapView.zoomLevel = 17
        mapView.showsUserLocation = true //显示用户位置
        mapView.userTrackingMode = .follow
        
        //搜索
        search = AMapSearchAPI()
        search.delegate = self
        
        //导航
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        //扫码页到输入密码通知
        NotificationCenter.default.addObserver(self, selector: #selector(handNumberShow), name: NSNotification.Name(rawValue: "HandNumber"), object: nil)
        
        //输入密码页到扫码通知
        NotificationCenter.default.addObserver(self, selector: #selector(scanVCShow), name: NSNotification.Name(rawValue: "ScanToUnLock"), object: nil)
    }
    
// MARK:- 手动输入车牌通知
    @objc func handNumberShow() {
        print("从我跳转")
        
        let vc = HandNumberVC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false) { 
            
        }
    }
    
// MARK:- 扫描二维码通知
    @objc func scanVCShow() {
        
        let vc = JTScanVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    
    
// MARK:- 搜索附近小黄车
    func searchNearBike() {
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    
    func searchCustomLocation (_ center : CLLocationCoordinate2D) {
        
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 500    //搜索半径
        
        search.aMapPOIAroundSearch(request)
    }
    
// MARK:- 大头针动画
    func pinAnimation() {
        
        let endFrame = pinView?.frame
        
        pinView?.frame = (endFrame?.offsetBy(dx: 0, dy: -15))!
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { 
            self.pinView?.frame = endFrame!
        }, completion: nil)
    }
    
    
// MARK:- 定位开始
    @IBAction func locationCLick(_ sender: UIButton) {
        nearBySearch = true
        searchNearBike()
    }
    
// MARK:- 障碍报修
    @IBAction func wrongClick(_ sender: UIButton) {
        
    }
    
    @IBAction func functionViewMove(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.functionView.transform = CGAffineTransform.init(translationX: 0, y: 200)
                self.locationBtn.transform = CGAffineTransform.init(translationX: 0, y: 200)
                self.wrongBtn.transform = CGAffineTransform.init(translationX: 0, y: 200)
            }, completion: { (Bool) in
                
            })
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.functionView.transform = .identity
                self.locationBtn.transform = .identity
                self.wrongBtn.transform = .identity
            }, completion: { (Bool) in
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK:- 高德地图代理方法
extension ViewController : MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate {
    
// MARK:- -----------------MAMapViewDelegate-----------------
    //地图初始化完成调用   加一个屏幕中间的大头针
    func mapInitComplete(_ mapView: MAMapView!) {
        
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate//定位在屏幕中心坐标
        pin.lockedScreenPoint = view.center //将大头针锁定在屏幕中心位置
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        
        searchNearBike()
    }
    
    
    
    /// 用户移动地图完成
    ///
    /// - Parameters:
    ///   - mapView: 地图视图
    ///   - wasUserAction: 是否是用户移动
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
        if wasUserAction {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(pin)
            
            mapView.removeOverlays(mapView.overlays);
            
            pin.isLockedToScreen = true
            pinAnimation()
            searchCustomLocation(mapView.centerCoordinate)
            
        }
    }
    
    //定制小黄车图标
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        //用户定义的位置  不需要自定义
        if annotation is MAUserLocation {
            return nil
        }
        
        if annotation is MyPinAnnotation {
            
            let reuseId = "anchor"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MAPinAnnotationView
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            
            annotationView?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            annotationView?.canShowCallout = false
            
            pinView = annotationView
            return annotationView
        }
        
        
        let reuseId = "myid"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MAPinAnnotationView
        
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        if annotation.title == "正常可用" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        } else {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        
        annotationView?.canShowCallout = true///是否允许弹出callout
        annotationView?.animatesDrop = false///添加到地图时是否使用下落动画效果
        
        return annotationView
    }
    
    
    /// 添加小黄车图标自定义动画
    ///
    /// - Parameters:
    ///   - mapView: 地图
    ///   - views: 小黄车标记
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aView in aViews {
            guard aView.annotation is MAPointAnnotation else {
                continue
            }
            
            aView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                aView.transform = .identity
            }, completion: nil)
            
        }
        
    }
    
    /// 地图上小黄车标记被点击
    ///
    /// - Parameters:
    ///   - mapView: 地图视图
    ///   - view: 小黄车标记视图
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("车被点击")
        
        start = pin.coordinate
        end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        
        
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
    }
    
    
    /// 绘制路线
    ///
    /// - Parameters:
    ///   - mapView: 地图
    ///   - overlay:
    /// - Returns:
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            
            pin.isLockedToScreen = false
            
            mapView.visibleMapRect = overlay.boundingMapRect
            
            let render = MAPolylineRenderer(overlay: overlay)
            render?.lineWidth = 8.0
            render?.strokeColor = UIColor.blue
            
            return render
        }
        
        return nil
    }
    
    
    
// MARK:- -----------------AMapSearchDelegate-----------------
    //搜索周边数据完成后回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        guard response.count > 0 else {
            print("周边没有小黄车")
            return
        }
        
        var annotations : [MAPointAnnotation] = []
        
        annotations = response.pois.map{
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if $0.distance < 200 {
                
                annotation.title = "红包区域内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得现金红包"
            } else {
                annotation.title = "正常可用"
            }
            return annotation
        }
        
        mapView.addAnnotations(annotations)
        
        if nearBySearch {
            mapView.showAnnotations(annotations, animated: true)
            nearBySearch = !nearBySearch
            mapView.centerCoordinate = mapView.userLocation.coordinate

        }
    }
    
// MARK:- -----------------AMapNaviWalkManagerDelegate-----------------
    
    /// 计算路线成功
    ///
    /// - Parameter walkManager:
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("计算路线成功")
        
        //去掉之前绘制的路线
        mapView.removeOverlays(mapView.overlays)
        
        //显示路径或开启导航
        var coordinates = walkManager.naviRoute!.routeCoordinates.map {
            
            return CLLocationCoordinate2D.init(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
            
        }
        
        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.add(polyline)
        
        
        //提示用距离和时间
        let walkMinutes = walkManager.naviRoute!.routeTime / 60
        
        var timeDesc = "1分钟以内"
        if walkMinutes > 0 {
            timeDesc = walkMinutes.description + "分钟"
        }
        
        let hintTitle = "步行" + timeDesc
        let hintSubtitle = "距离" + walkManager.naviRoute!.routeLength.description + "米"
        
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubtitle)
        
    }
    
    /**
     * @brief 发生错误时,会调用代理的此方法
     * @param walkManager 步行导航管理类
     * @param error 错误信息
     */
    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
        print("计算路线失败", error)
    }
}























