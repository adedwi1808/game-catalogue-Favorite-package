//
//  FavoriteViewController.swift
//  game-catalogue-uikit
//
//  Created by Ade Dwi Prayitno on 20/11/25.
//

import Common
import Components
import Core
import SkeletonView
import UIKit

public class FavoriteViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        return tableView
    }()

    private let refreshControl = UIRefreshControl()
    private let presenter: FavoritePresenter

    public init(presenter: FavoritePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showShimmer()
        presenter.getLocaleGames()
    }

    private func setupView() {
        setupNavigationBar()
        setupTableView()
        setupConstraint()
    }

    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(
            frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "favorite_title".localized
    }

    private func setupTableView() {
        tableView.isSkeletonable = true
        tableView.separatorStyle = .none

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh),
            for: .valueChanged
        )

        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            GameTableViewCell.self,
            forCellReuseIdentifier: GameTableViewCell.name
        )
    }

    private func setupConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func showShimmer() {
        tableView.showAnimatedGradientSkeleton(
            usingGradient: SkeletonGradient(
                baseColor: UIColor(white: 0.82, alpha: 1.0),
                secondaryColor: UIColor(white: 0.92, alpha: 1.0)
            ),
            animation: nil,
            transition: .none
        )
    }

    private func loadLocaleData() {
        presenter.getLocaleGames()
    }

    @objc private func handleRefresh() {
        loadLocaleData()
    }
}

extension FavoriteViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        presenter.games.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let data: Game = presenter.games[indexPath.row]
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: GameTableViewCell.name,
                for: indexPath
            ) as? GameTableViewCell
        cell?.configure(data: data)
        return cell ?? UITableViewCell()
    }
}

extension FavoriteViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        10
    }

    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        130
    }

    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if tableView.sk.isSkeletonActive { return }
        guard indexPath.row < presenter.games.count else { return }
        presenter.didSelectItem(
            at: indexPath.row,
            from: self
        )

    }
}

extension FavoriteViewController: FavoriteViewProtocol {
    public func onSuccess() {
        refreshControl.endRefreshing()
        tableView.hideSkeleton()
        tableView.reloadData()

        if !presenter.games.isEmpty {
            tableView.scrollToRow(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: true
            )
        }
    }

    public func onFailed(message: String) {
        refreshControl.endRefreshing()
        let alertController = UIAlertController(
            title: "failed_fetch_data".localized,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "ok_action".localized, style: .default))

        present(alertController, animated: true)

        self.tableView.tableFooterView = nil
    }

    public func onLoading(_ isLoading: Bool) {
        if isLoading {
            self.tableView.tableFooterView = createSpinnerFooter()
        } else {
            self.tableView.tableFooterView = nil
        }
    }
}

extension FavoriteViewController: SkeletonTableViewDataSource {
    nonisolated public func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }

    nonisolated public func collectionSkeletonView(
        _ skeletonView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        3
    }

    nonisolated public func collectionSkeletonView(
        _ skeletonView: UITableView,
        cellIdentifierForRowAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        "GameTableViewCell"
    }
}
