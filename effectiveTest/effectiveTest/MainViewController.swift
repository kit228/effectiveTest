//
//  ViewController.swift
//  effectiveTest
//
//  Created by Вениамин Китченко on 04.07.2020.
//  Copyright © 2020 Вениамин Китченко. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var requestDumbString: String = "https://gitlab.com/api/v4/projects?simple=true&per_page=3&page=" // строка для url-запроса
    var requestDumbString: String = "https://gitlab.com/api/v4/projects?per_page=8&page=" // строка для url-запроса
    var requestPage: Int = 1 // переменная номера запрошенной страницы
    //var testText = ["Перывй заголовок","Второй заголовок"]
    var choosedProjectSection: Int = Int() // индекс выбранной секции c проектом (нужно для передачи ссылки в во вьюшкой с WebView)
    
    var arrayOfGitlabProjects: [ProjectFromGitlab] = [] // массив проектов из гитлаба
    
    let imageCache = NSCache<AnyObject, AnyObject>() // создаем кэш
    
    @IBOutlet weak var tableView: UITableView! // outlet tableView со списком
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // разделители секций tableView (header)
        let label = UILabel()
        //label.text = "Имя проекта"
        //label.text = testText[section]
        label.text = arrayOfGitlabProjects[section].name
        label.backgroundColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 30)
        //label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center // центрируем лэйбл
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { // размер разделителя секций tableView (хедера)
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // устанавливаем количество секций
        return arrayOfGitlabProjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // количество ячеек
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // заполяем ячейки
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAvatarAndDescription") as! AvatarAndDescriptionTableViewCell
            
            // делаем картинку круглой (пока хардкодом)
            var cellImageLayer = cell.avatarImageView.layer
            cellImageLayer.cornerRadius = 58
            //cellImageLayer.masksToBounds = true
            
            //cell.projectDescriptionTextView.text = "kek"
            // заполняем описание проекта (пока не в две строки, а все, что есть через скролл)
            if let description = arrayOfGitlabProjects[indexPath.section].description {
                cell.projectDescriptionTextView.text = description
            }
            
            
            // грузим картинку (если есть ссылка) - данное поведение НЕВЕРНО, поскольку не кешируется и каждый раз грузится!
            if let imageUrlString = arrayOfGitlabProjects[indexPath.section].avatar_url {
                
                guard let imageUrl = URL(string: imageUrlString) else {return cell}
                
                URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in // делаем запрос URLSession
                    guard let responsedData = data else { // unwrapped data
                        print("Ошибка при загрузки картинки")
                        return
                    }
                    
                    cell.avatarImageView.image = UIImage(data: responsedData)
                    
                    DispatchQueue.main.async { // обновляем в main потоке collectionView
                        self.tableView.reloadData() // обновляем collectionView
                    }
                    
                }
                .resume() // для URLdataTask
            }
            
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellStarsAndForks") as! StarsAndForksTableViewCell
            
            //cell.stairsAndForksLabel?.text = "kek2"
            // заполняем звезды и форки
            var starsAndForks = ""
            if let stars = arrayOfGitlabProjects[indexPath.section].star_count {
                starsAndForks = String(stars) + " Stars, "
            }
            if let forks = arrayOfGitlabProjects[indexPath.section].forks_count {
                starsAndForks = starsAndForks + String(forks) + " Forks"
            }
            
            cell.stairsAndForksLabel.text = starsAndForks
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAuthorName") as! AuthorNameTableViewCell
            
            //cell.authorNameLabel?.text = "kek3"
            // заполняем имя автора
            if let authorName = arrayOfGitlabProjects[indexPath.section].ownerName {
                cell.authorNameLabel.text = authorName
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // действие при нажатии на ячейку
        tableView.deselectRow(at: indexPath, animated: true) // снимаем подсвечивание выбранной строки после касания
        //print("Нажата ячейка")
        choosedProjectSection = indexPath.section // записываем выбранное значение секции проекта
        performSegue(withIdentifier: "toWebViewSegue", sender: self) // переход на экран ShowProjectInWebViewController с помощью сегвея toWebViewSegue
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { // подгрузка при последней секции с помощью willDisplay (почему-то запускается три раза)
        let lastSection = arrayOfGitlabProjects.count - 1
        if indexPath.section == lastSection {
            print("Последняя секция")
            getGitlabProject() // делаем url-запрос на получение проектов из гитлаба
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // передаем через сегвей toWebViewSegue ссылку проекта
        if segue.identifier == "toWebViewSegue" {
            if let toShowProjectInWebView = segue.destination as? ShowProjectInWebViewController {
                toShowProjectInWebView.urlStringToLoad = arrayOfGitlabProjects[choosedProjectSection].web_url
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestPage = Int(arc4random_uniform(3000)) // получаем рандомный номер первой страницы
        getGitlabProject() // делаем url-запрос на получение проектов из гитлаба
    }
    
    func getGitlabProject() { // делаем url get-запрос на получение проектов из гитлаба
        guard let url = URL(string: requestDumbString + String(requestPage)) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in // делаем url запрос
            guard let responsedData = data else {
                print("Не был получен ответ на запрос в гитлаб, ошибка \(error)")
                return
            }
            
            // парсим json-ответ
            do {
                //let parsedResponse = try JSONDecoder().decode(JsonAnswerDecodable.ResponseFromGitLabStruct.self, from: responsedData)
                let parsedResponse = try JSONDecoder().decode(Array<JsonAnswerDecodable.ResponseArrayStruct>.self, from: responsedData)
                print("json-ответ от гитлаба распарсен успешно: \(parsedResponse)")
                
                
                // заполняем массив проектов из гитлаба
                for element in parsedResponse {
                    self.arrayOfGitlabProjects.append(ProjectFromGitlab(name: element.name, description: element.description, web_url: element.web_url, avatar_url: element.avatar_url, forks_count: element.forks_count, star_count: element.star_count, ownerName: element.owner?.name))
                }
                
                DispatchQueue.main.async { // обновляем tableView
                    self.tableView.reloadData()
                }
                
            }
            catch let parsengResponseError {
                print("Ошибка парсинга json-ответа от гитлаба: \(parsengResponseError)")
            }
        }
    .resume() // для URLdatatask
        
        requestPage += 1 // прибавляем запрашиваемую страницу, чтобы при следующем запросе получить новые проекты
    }
    

}

